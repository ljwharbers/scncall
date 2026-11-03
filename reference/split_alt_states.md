# Alternative states of a clone segment for the disagreement split

The states a sub-population of a clone could carry on a segment in clone
state `state`: states of the grid (major haplotype first, at least one
copy) within one copy of its total copy number. An alternative whose
major fraction differs by less than `min_df` (a depth-only difference)
is kept only when one of the two states has \<= 2 copies (2:0 vs 1:0 vs
3:0): between amplified states one copy is a small log2 step, and
amplicon copy number varies continuously between cells (e.g. an 8q
amplicon at cn 6-16), as
[`clone_state_distance()`](https://ljwharbers.github.io/scphasedcn/reference/clone_state_distance.md)
also ignores it.

## Usage

``` r
split_alt_states(state, grid = cn_grid(), min_df = 0.15)
```

## Arguments

- state:

  clone state (`"nA:nB"`)

- grid:

  state grid
  ([`cn_grid()`](https://ljwharbers.github.io/scphasedcn/reference/cn_grid.md))

- min_df:

  minimal major-fraction difference of an alternative between amplified
  states

## Value

grid rows of the alternatives (state, nA, nB, cn, f, label)
