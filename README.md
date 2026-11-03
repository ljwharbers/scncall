# scncall

Single-cell copy-number calling for **SPLONGGET**: single-cell long-read DNA sequencing in which every read carries a
10x Multiome cell barcode and is sequenced on Oxford Nanopore. scncall combines read depth with read-phased alleles
(each molecule covering a phased heterozygous SNP votes for a haplotype), per cell and region:

- **normal tissue**: rare, cell-private gains, losses and copy-neutral LOH, with thresholds calibrated on null cells
  (1 false call per 1,000 null cell-regions), per cell and in cell pools;
- **tumours**: clone discovery, allele-specific clone copy-number profiles, likelihood assignment of every cell,
  per-cell inherited / confirmed calls, and input for MEDICC2 trees.

The repository holds two packages that are used together:

| package | language | does |
|---|---|---|
| `splongcn` (`python/`) | Python (pysam) | BAM -> extraction directory: per-cell 100 kb bin counts, a fragment table with haplotypes, cell QC |
| `scncall` (root) | R | extraction directory -> calls, clones, tables |

## Install

Container (Docker / Apptainer / Singularity; R, Python, both packages and htslib):

```bash
apptainer pull docker://ghcr.io/ljwharbers/scncall:0.1.0
apptainer exec scncall_0.1.0.sif splongcn --help
```

Conda (from a checkout):

```bash
git clone https://github.com/ljwharbers/scncall && cd scncall
conda env create -f environment.yml && conda activate scncall      # or micromamba
pip install ./python && R CMD INSTALL .
bash tools/smoke_test.sh                                            # end-to-end check on simulated data
```

From source into existing installations: `pip install ./python` (Python >= 3.10) and, in R (>= 4.2),
`install.packages("pak"); pak::pak("ljwharbers/scncall")` (Bioconductor dependencies: rhdf5, Rsamtools). A `tabix` on
the PATH speeds up reading the fragment table.

## Quick start

```bash
# 1. phased heterozygous SNPs (Clair3 + longphase on the pooled BAM; see vignette("scncall-inputs"))
splongcn select-hets --vcf sample.longphase.vcf.gz --loci 1000G_snvs_hg38.vcf.gz --out het_phased.vcf.gz

# 2. extraction (all chromosomes in parallel, then merge)
splongcn run --bam sample.bam --barcodes barcodes.tsv.gz --fasta GRCh38.fa \
    --snps het_phased.vcf.gz --phased --out results/sample/extract --jobs 8

# 3. calling
CALL=$(Rscript -e 'cat(system.file("scripts", "call_scn.R", package = "scncall"))')   # in the container: call_scn.R
Rscript $CALL --dir results/sample/extract --out results/sample/caller --sex female --mode normal --null-cells select
```

or in R:

```r
library(scncall)
res = call_scn("results/sample/extract", mode = "tumour", sex = "male")
write_scncall(res, "results/sample/caller")
```

Documentation: https://ljwharbers.github.io/scncall/, or in R `vignette("scncall")` (overview and a run on simulated data), `vignette("scncall-inputs")` (input
requirements, phasing recipe, extraction, cell metadata), `vignette("scncall-outputs")` (result tables).

Scope: GRCh38 / hg38 with `chr` names; Linux and macOS.

## Citation

Please cite the SPLONGGET paper (reference to be added on publication) and the package: `citation("scncall")`.

## License

MIT (`LICENSE.md`). The bundled ENCODE blacklist (Amemiya et al. 2019) and centromere coordinates (Battenberg) are
credited in `python/src/splongcn/resources/README.md`.
