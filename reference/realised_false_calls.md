# Realised false-call rates on the null rows

Realised false-call rates on the null rows

## Usage

``` r
realised_false_calls(
  d,
  scores = "s_comb",
  by = c("class", "stratum"),
  null = NULL
)
```

## Arguments

- d:

  rows with `call_<score>` columns
  ([`apply_thresholds()`](https://ljwharbers.github.io/scphasedcn/reference/apply_thresholds.md))
  and a null definition

- scores:

  scores (without the `call_` prefix)

- by:

  grouping of the per-1,000 rates

- null:

  optional null flag per row

## Value

list: `rates` (by, score, n_null, n_called, per_1000) and `per_cell`
(score, n_cells, events_per_cell = called autosomal arm null rows per
null cell averaged over null cells (the D1' analogue), frac_cells =
fraction of null cells with at least one)
