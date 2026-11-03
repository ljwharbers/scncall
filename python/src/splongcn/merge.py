"""Merge per-chromosome partials into the per-sample outputs (layout: the scncall-inputs vignette)."""
from __future__ import annotations

import json
import os
import time
from pathlib import Path

import anndata as ad
import numpy as np
import pandas as pd
import pysam
import scipy.sparse as sp

from .qc import finalize_qc
from .writers import load_csr_dict, concat_bgzf, write_json, FRAGMENT_COLUMNS


def _read_cells(pdir: Path) -> list[str]:
    return [l.rstrip("\n") for l in open(pdir / "cells.txt") if l.strip()]


def _stack_layers(dirs: list[Path], fname: str) -> dict[str, sp.csr_matrix]:
    """hstack per-chromosome CSR layers; a layer missing on some chromosome is zero there."""
    per = [load_csr_dict(d / fname) for d in dirs]
    names = []
    for p in per:
        names += [k for k in p if k not in names]
    out = {}
    for k in names:
        mats = []
        for p in per:
            if k in p:
                mats.append(p[k])
            else:
                ref = next(iter(p.values()))
                mats.append(sp.csr_matrix(ref.shape, dtype=ref.dtype))
        out[k] = sp.hstack(mats, format="csr")
    return out


def _sum_obsm(dirs: list[Path], fname: str) -> dict[str, np.ndarray]:
    out = {}
    for d in dirs:
        z = np.load(d / fname)
        for k in z.files:
            out[k] = out.get(k, 0) + z[k]
    return out


def _bins(dirs: list[Path], fname: str) -> pd.DataFrame:
    return pd.concat([pd.read_csv(d / fname, sep="\t", index_col=0) for d in dirs])


def _qc(dirs: list[Path], fname: str) -> tuple[pd.DataFrame, dict]:
    per_chrom_pass = {}
    tot = None
    for d in dirs:
        q = pd.read_csv(d / fname, sep="\t", index_col=0)
        per_chrom_pass[d.name] = q["n_pass"].values if "n_pass" in q else None
        tot = q if tot is None else tot.add(q, fill_value=0)
    return tot, per_chrom_pass


def _snps(dirs: list[Path]) -> pd.DataFrame:
    df = pd.concat([pd.read_csv(d / "snps.tsv", sep="\t", index_col=0) for d in dirs])
    for c, t in (("pos", np.int64), ("hap_of_alt", np.int8), ("ps", np.int64), ("n_other", np.int64), ("n_lowbq", np.int64)):
        if c in df:
            df[c] = df[c].astype(t)
    for c in ("chrom", "ref", "alt"):
        df[c] = df[c].astype(str)
    df.index = df.index.astype(str)
    return df


def _uns_safe(d):
    out = {}
    for k, v in d.items():
        if isinstance(v, dict):
            out[k] = _uns_safe(v)
        elif v is None:
            out[k] = "None"
        elif isinstance(v, (list, tuple)):
            out[k] = [str(x) if x is None else x for x in v]
        else:
            out[k] = v
    return out


def merge_sample(out: str, chroms: list[str], tag: str = "100kb", keep_partials: bool = True) -> dict:
    t0 = time.time()
    out = Path(out); P = out / "partials"
    dirs = [P / c for c in chroms if (P / c / "DONE").exists()]
    missing = [c for c in chroms if not (P / c / "DONE").exists()]
    if not dirs:
        raise SystemExit(f"no finished partials under {P}")
    first = dirs[0]
    cells = _read_cells(first)
    params = json.load(open(first / "params.json"))
    summary = {"chroms": [d.name for d in dirs], "missing": missing, "n_cells": len(cells), "params": params}
    # --- bins (depth layers) ---
    if (dirs[0] / "layers.npz").exists():
        ldirs = [d for d in dirs if (d / "layers.npz").exists()]
        layers = _stack_layers(ldirs, "layers.npz")
        if all((d / "alleles.npz").exists() for d in ldirs):
            al = _stack_layers(ldirs, "alleles.npz")
            for k in ("hapA", "hapB", "hap_ambig"):
                if k in al:
                    layers[k] = al[k]
        obsm = _sum_obsm(ldirs, "obsm.npz")
        bins = _bins(ldirs, "bins.tsv")
        qc, per_chrom_pass = _qc(ldirs, "qc.tsv")
        if all((d / "alleles_qc.tsv").exists() for d in ldirs):
            aq, _ = _qc(ldirs, "alleles_qc.tsv")
            for c in aq.columns:
                qc[c] = aq[c]
        qc = finalize_qc(qc, per_chrom_pass, peaks_given=bool(params.get("peaks")))
        qc = qc.loc[cells]
        X = layers.pop("counts")
        a = ad.AnnData(X=X, obs=qc, var=bins, layers=layers, obsm={k: v.astype(np.int32) for k, v in obsm.items()})
        a.uns["params"] = _uns_safe(params)
        a.uns["obsm_layout"] = _uns_safe(obsm_layout())
        a.write_h5ad(out / f"bins_{tag}.h5ad", compression="gzip")
        qc.to_csv(out / "cells_qc.tsv", sep="\t")
        summary["bins"] = {"n_bins": int(a.n_vars), "total_counts": int(X.sum()), "layers": list(layers.keys())}
        for k in ("n_pass", "n_clean"):
            if k in qc:
                summary[f"median_{k}"] = float(np.median(qc[k]))
    # --- alleles (DNA) ---
    adirs = [d for d in dirs if (d / "alleles.npz").exists()]
    if adirs:
        al = _stack_layers(adirs, "alleles.npz")
        snps = _snps(adirs)
        a = ad.AnnData(X=al["DP"], obs=pd.DataFrame(index=cells), var=snps, layers={"AD": al["AD"]})
        a.uns["params"] = _uns_safe(params)
        a.write_h5ad(out / "alleles_dna.h5ad", compression="gzip")
        summary["alleles_dna"] = {"n_snps": int(a.n_vars), "n_phased": int((snps["hap_of_alt"] > 0).sum()),
                                  "total_dp": int(al["DP"].sum()), "total_ad": int(al["AD"].sum())}
    # --- fragments table ---
    parts = [str(d / "fragments.tsv.gz") for d in dirs if (d / "fragments.tsv.gz").exists()]
    if parts:
        fn = out / "fragments.tsv.gz"
        concat_bgzf(parts, str(fn), header=FRAGMENT_COLUMNS)
        if os.path.exists(str(fn) + ".tbi"):
            os.remove(str(fn) + ".tbi")
        pysam.tabix_index(str(fn), seq_col=0, start_col=1, end_col=2, zerobased=True, force=True, meta_char="#")
        summary["fragments"] = str(fn)
    summary["merge_seconds"] = round(time.time() - t0, 1)
    write_json(out / "summary.json", summary)
    return summary


def obsm_layout() -> dict:
    from .depth import FRAGLEN_LABELS
    return {
        "fraglen_hist": FRAGLEN_LABELS,
        "mapq_hist": ["mapq0", "mapq1_29", "mapq30_59", "mapq60"],
    }
