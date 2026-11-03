# Window count matrices for clone pseudobulks

Observed and expected fragments summed over the usable bins of
[`window_ids()`](https://ljwharbers.github.io/scphasedcn/reference/window_ids.md)
windows (default 1 Mb).

## Usage

``` r
window_matrices(scn, norm, size = 1e+06)
```

## Arguments

- scn:

  scn object

- norm:

  `scn_norm`
  ([`normalise_depth()`](https://ljwharbers.github.io/scphasedcn/reference/normalise_depth.md))

- size:

  window size (bp)

## Value

list `x`, `e` (windows x cells matrices, row names = window ids, column
names = cells) and `windows` (window, chrom, start, end, n_use)
