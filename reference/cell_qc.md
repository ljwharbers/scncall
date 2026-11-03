# Cell QC of the caller

A cell passes when it has at least `min_frag` clean fragments, a
fraction of MAPQ-60 fragments of at least `min_mapq60` and at most
`max_chrM` chrM fragments. Clean fragments are `n_clean`, falling back
to `n_pass` and then `n_frag`. A QC column that is missing from the cell
table is not applied; an NA value fails the cell (`qc_pass == TRUE` is
required), except NA `frac_chrM`, which passes.

## Usage

``` r
cell_qc(
  scn,
  min_frag = 5000,
  min_mapq60 = 0.5,
  max_chrM = 0.2,
  params = caller_defaults()
)
```

## Arguments

- scn:

  scn object (uses `scn$cells`) or a cell table

- min_frag:

  minimal clean fragments

- min_mapq60:

  minimal fraction of MAPQ-60 fragments

- max_chrM:

  maximal fraction of chrM fragments

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)
  (depth strata)

## Value

data.table `cell, qc_pass, stratum, n_frag`
