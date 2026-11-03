# Pooled state scores

Per pool (x `by` group, e.g. region): the per-state depth LLRs and the
per-row allelic LLRs are summed over the pool's rows, then each state
takes its best row (depth + alleles); scores as in
[`score_cells()`](https://ljwharbers.github.io/scphasedcn/reference/score_cells.md)
(`s_depth` = best pooled depth LLR over the states with a depth shift).

## Usage

``` r
pool_scores(
  d,
  pools = NULL,
  states = caller_states("normal"),
  by = intersect(c("region", "class"), names(d)),
  loo = FALSE,
  scale = NULL
)
```

## Arguments

- d:

  rows scored with `keep_rows = TRUE`
  ([`score_cells()`](https://ljwharbers.github.io/scphasedcn/reference/score_cells.md));
  with a `pool` column when `pools` is NULL

- pools:

  NULL or a table `pool`, `cell` (a cell may be in several pools)

- states:

  the state set used for scoring

- by:

  grouping within a pool (default region and class when present)

- loo:

  add the leave-one-out scores `s_loo`, `s_rob`, `state_rob`,
  `lo_<state>`

- scale:

  NULL or a
  [`pool_scale()`](https://ljwharbers.github.io/scphasedcn/reference/pool_scale.md)
  table (per-region null median / MAD of the pooled best LLR)

## Value

data.table pool, by, n, cl\_, s_depth, state_depth, s_allelic,
state_allelic, s_comb, state_comb (+ s_loo, s_rob, state_rob, lo\_; +
s_comb_llr with `scale`)

## Details

Leave-one-out (`loo = TRUE`): for every state row (depth + one allelic
row) the largest single-cell contribution is removed from the pooled
sum; `s_loo` is the best such row of the called state (`state_comb`) and
`s_rob = pmin(s_comb, s_loo)`: a pool passes on `s_rob` only if it still
passes after dropping its most influential cell, so one strong carrier
cannot make ~20 overlapping kNN pools call. `state_rob` = `state_comb`;
`lo_<state>` holds every state's leave-one-out score.

Region scale (`scale`, a
[`pool_scale()`](https://ljwharbers.github.io/scphasedcn/reference/pool_scale.md)
table of null pools of the same construction): the best state is chosen
on the LLRs, then `s_comb` and `s_loo` are standardised per region,
`(s - med) / mad` of the region's null pools; `s_comb_llr` keeps the raw
best LLR.
