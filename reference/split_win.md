# Split window depth into two independent halves

Binomial thinning of the 1 Mb window counts (`x`; probability `frac`)
with the expected counts scaled by `frac` and `1 - frac`: the depth
analogue of
[`split_votes()`](https://ljwharbers.github.io/scphasedcn/reference/split_votes.md).
Clone discovery uses one half and the merge / split tests the other, so
a depth difference that formed two leaves is not tested on the same
counts.

## Usage

``` r
split_win(win, frac = 0.5, seed = 1)
```

## Arguments

- win:

  1 Mb window depth list(windows, x, e)

- frac:

  fraction of the counts in the first half

- seed:

  RNG seed

## Value

list(disc, test): window depth lists
