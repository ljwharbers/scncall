"""Per-cell x bin depth layers from fragment arrays (vectorised numpy accumulators)."""
from __future__ import annotations

import numpy as np
import scipy.sparse as sp

from .bam import ChromFragments, F_BLACKLIST
from .bins import Tiling

ASSIGN_MODES = ("start", "midpoint", "end5", "overlap")
FRAGLEN_EDGES = np.array([0, 200, 300, 500, 750, 1000, 2000, 5000, 10000, np.inf])
FRAGLEN_LABELS = ["lt200", "200_300", "300_500", "500_750", "750_1000", "1k_2k", "2k_5k", "5k_10k", "ge10k"]


def assigned_position(fr: ChromFragments, assign: str) -> np.ndarray:
    if assign == "start":
        return fr.start
    if assign == "midpoint":
        return (fr.start + fr.end) // 2
    if assign == "end5":
        return np.where(fr.strand == 0, fr.start, fr.end - 1)
    raise ValueError(assign)


def accumulate(cell: np.ndarray, bin_idx: np.ndarray, n_cells: int, n_bins: int, weights=None) -> sp.csr_matrix:
    """cells x bins CSR of counts (or summed weights) for entries with bin_idx >= 0."""
    ok = bin_idx >= 0
    key = cell[ok].astype(np.int64) * n_bins + bin_idx[ok]
    w = None if weights is None else weights[ok]
    dense = np.bincount(key, weights=w, minlength=n_cells * n_bins).reshape(n_cells, n_bins)
    m = sp.csr_matrix(dense.astype(np.int64 if w is None else np.float64))
    m.eliminate_zeros()
    return m


def depth_layers(fr: ChromFragments, tiling: Tiling, n_cells: int, assign: str = "start",
                 use: np.ndarray | None = None) -> dict:
    """counts / span / frag_short / frag_long / hapA / hapB / hap_ambig layers; `use` selects fragments (default: not blacklisted)."""
    if use is None:
        use = (fr.flags & F_BLACKLIST) == 0
    nb = len(tiling)
    cell = fr.cell[use]; start = fr.start[use]; end = fr.end[use]; L = end - start
    out = {}
    if assign == "overlap":
        fi, bi = tiling.bins_overlapping(start, end)
        c = cell[fi]
        bases = np.minimum(end[fi], tiling.ends[bi]) - np.maximum(start[fi], tiling.starts[bi])
        out["counts"] = accumulate(c, bi, n_cells, nb)
        out["span"] = accumulate(c, bi, n_cells, nb, weights=bases.astype(np.float64))
        out["frag_short"] = accumulate(c[L[fi] < 300], bi[L[fi] < 300], n_cells, nb)
        out["frag_long"] = accumulate(c[L[fi] >= 1000], bi[L[fi] >= 1000], n_cells, nb)
        hap = fr.hap[use][fi]; bi_h = bi
    else:
        pos = assigned_position(fr, assign)[use]
        bi = tiling.bin_of(pos)
        out["counts"] = accumulate(cell, bi, n_cells, nb)
        out["span"] = accumulate(cell, bi, n_cells, nb, weights=L.astype(np.float64))
        out["frag_short"] = accumulate(cell[L < 300], bi[L < 300], n_cells, nb)
        out["frag_long"] = accumulate(cell[L >= 1000], bi[L >= 1000], n_cells, nb)
        hap = fr.hap[use]; c = cell; bi_h = bi
    for code, name in ((1, "hapA"), (2, "hapB"), (3, "hap_ambig")):
        sel = hap == code
        out[name] = accumulate(c[sel], bi_h[sel], n_cells, nb)
    for k in out:
        out[k] = out[k].astype(np.float64 if k == "span" else np.int32)
    return out


def fraglen_hist(fr: ChromFragments, n_cells: int, use: np.ndarray | None = None) -> np.ndarray:
    if use is None:
        use = (fr.flags & F_BLACKLIST) == 0
    L = (fr.end - fr.start)[use]
    b = np.searchsorted(FRAGLEN_EDGES, L, side="right") - 1
    b = np.clip(b, 0, len(FRAGLEN_LABELS) - 1)
    return np.bincount(fr.cell[use].astype(np.int64) * len(FRAGLEN_LABELS) + b,
                       minlength=n_cells * len(FRAGLEN_LABELS)).reshape(n_cells, len(FRAGLEN_LABELS))
