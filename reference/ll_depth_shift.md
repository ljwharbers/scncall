# Depth log-likelihood ratio of a location shift

`log f0(z - mu) - log f0(z)`: the evidence that a cell-region's window z
(`log2ratio / pmax(sd_null, sd_floor)`) is shifted by `mu` (a state's
log2 shift divided by the same floored `sd_null`). `f0` is the
location-scale Student-t fitted to the null z of the row's class x
stratum when `tpar` is given (`dt((x - t_m) / t_s, t_df)`;
[`fit_depth_null()`](https://ljwharbers.github.io/scphasedcn/reference/fit_depth_null.md)),
else N(0, 1) (`mu * z - mu^2 / 2`). Missing z contributes 0 (no
evidence). This is the depth part (`dl_loss`, `dl_gain`) of the region
score of
[`score_cells()`](https://ljwharbers.github.io/scphasedcn/reference/score_cells.md).

## Usage

``` r
ll_depth_shift(z, mu, tpar = NULL)
```

## Arguments

- z:

  window z per row (NA allowed)

- mu:

  shift in z units (scalar or one per row)

- tpar:

  NULL (Gaussian) or the t parameters: a list / 1-row data.table with
  `t_m`, `t_s`, `t_df`, or the same columns with one value per row

## Value

numeric vector (length of z)
