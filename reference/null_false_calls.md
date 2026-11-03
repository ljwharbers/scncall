# Realised false calls on the null rows of a scored table

Rates per class x depth stratum (and per class over all strata) of
`call_s_comb` on the null rows (`is_null`, else
`null_cell & null_region & eligible`), and the per-null-cell false arm
events (called autosomal arm null rows per null cell), overall and per
called state.

## Usage

``` r
null_false_calls(scores)
```

## Arguments

- scores:

  scored table with `call_s_comb`
  ([`caller_normal()`](https://ljwharbers.github.io/scphasedcn/reference/caller_normal.md)'s
  `scores`)

## Value

list(rates = data.table class, stratum, n_null, n_called, per_1000;
events = data.table state, n_cells, arm_calls_per_cell, frac_cells)
