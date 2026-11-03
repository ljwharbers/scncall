# splongcn

Extraction layer of the [scncall](https://github.com/ljwharbers/scncall) single-cell copy-number caller. One pass
per chromosome over a SPLONGGET DNA BAM (10x Multiome barcodes in the `CB` tag, Oxford Nanopore reads) writes the
directory scncall reads:

- `bins_100kb.h5ad`: fragment counts per cell x 100 kb bin, with GC, blacklist / tandem-repeat fractions and
  centromere flags per bin;
- `fragments.tsv.gz` + `.tbi`: one row per fragment with cell, flags, haplotype (from phased heterozygous SNPs) and
  phase set;
- `cells_qc.tsv`: per-cell QC; `alleles_dna.h5ad`: allele counts per cell x SNP; `summary.json`.

```bash
pip install ./python            # or: the scncall container / conda environment
splongcn run --bam sample.bam --barcodes barcodes.tsv.gz --fasta GRCh38.fa \
    --snps het_phased.vcf.gz --phased --out results/sample/extract --jobs 8
```

`splongcn run` extracts every chromosome in parallel and merges; `splongcn extract --chrom <c>` and
`splongcn merge` are the same steps for one cluster job per chromosome. `splongcn select-hets` selects the
heterozygous SNVs of a phased VCF (Clair3 + longphase) for `--snps`. `splongcn index-check` checks the BAM index
and can write a fresh one to a separate path (`--reindex`, then `--index` in `extract` / `run`).
See `splongcn <command> --help` and the scncall documentation for the input requirements and the phasing recipe.

Options worth knowing:

- `--barcode-map`: a TSV with columns `atac_barcode` and `rna_barcode`. A whitelist in RNA-barcode space (10x
  Multiome GEX barcodes) is translated to the ATAC barcodes of the BAM's `CB` tag.
- `--peaks`: an optional peak BED file (a file, not a directory) for FRiP per cell and `peak_bp` per bin (QC only).
- `--layers`: a comma list of `depth`, `alleles`, `fragments`, `qc` (default: all four, which is what scncall
  reads). `--layers alleles,fragments` recomputes the allele layer alone, e.g. with a new VCF.

Genome: GRCh38 / hg38 with `chr` names (bundled chromosome sizes, ENCODE blacklist v2 and centromeres; see
`src/splongcn/resources/README.md`).
