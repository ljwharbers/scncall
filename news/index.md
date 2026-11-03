# Changelog

## scphasedcn 0.1.0

First public release of scphasedcn.

- [`call_scn()`](https://ljwharbers.github.io/scphasedcn/reference/call_scn.md):
  copy-number calls per cell and region from an extraction directory
  (`scphasedcn run`), combining read depth and read-phased alleles.
  - Normal-tissue mode
    ([`caller_normal()`](https://ljwharbers.github.io/scphasedcn/reference/caller_normal.md)):
    null cells selected from the data, Student-t / beta-binomial nulls,
    fold-cross-validated thresholds at 1 false call per 1,000 null
    cell-regions, per-cell and pooled calls, events.
  - Tumour mode
    ([`caller_tumour()`](https://ljwharbers.github.io/scphasedcn/reference/caller_tumour.md)):
    clone discovery, allele-specific clone copy-number states,
    likelihood assignment of every cell, per-cell inherited and
    confirmed calls, MEDICC2 input
    ([`medicc2_pieces()`](https://ljwharbers.github.io/scphasedcn/reference/medicc2_pieces.md),
    [`medicc2_table()`](https://ljwharbers.github.io/scphasedcn/reference/medicc2_table.md)).
- [`write_scphasedcn()`](https://ljwharbers.github.io/scphasedcn/reference/write_scphasedcn.md)
  /
  [`read_scphasedcn()`](https://ljwharbers.github.io/scphasedcn/reference/read_scphasedcn.md):
  flat result tables, the parameters used (`params.yaml`) and run notes.
- Command line:
  `system.file("scripts", "call_scn.R", package = "scphasedcn")`, on
  `--dir` + `--out`, or on a sample yaml
  (`inst/extdata/sample_template.yaml`) with `--config` + `--sample`.
- [`make_cell_meta()`](https://ljwharbers.github.io/scphasedcn/reference/make_cell_meta.md):
  the cell metadata table (cell types, known copy-number-flat cells,
  groups) from the extractor’s `cells_qc.tsv` and your own labels.
- The hg38 centromere table ships with the package
  ([`hg38_centromeres()`](https://ljwharbers.github.io/scphasedcn/reference/hg38_centromeres.md));
  the chrX centromere is masked like the autosomal ones.
- [`simulate_scn()`](https://ljwharbers.github.io/scphasedcn/reference/simulate_scn.md)
  /
  [`write_sim_dataset()`](https://ljwharbers.github.io/scphasedcn/reference/write_sim_dataset.md):
  simulated SPLONGGET-like data in the extractor’s layout.
- Vignettes: getting started, inputs (phasing recipe, extraction, cell
  metadata), outputs.
