# Split molecule votes into two independent halves

Binomial thinning of each cell x atom x phase-set count (`nA` and `nB`
separately, probability `frac`): molecule votes are independent, so the
halves are independent samples of the same cells. Clone discovery
clusters cells on one half and
[`merge_clones()`](https://ljwharbers.github.io/scphasedcn/reference/merge_clones.md)
tests the leaves on the other; testing leaves on the data that formed
them inflates every contrast (leaves are selected to differ), which a
permutation null of random splits does not reproduce.

## Usage

``` r
split_votes(votes, frac = 0.5, seed = 1)
```

## Arguments

- votes:

  votes table

- frac:

  fraction of the votes in the first half

- seed:

  RNG seed

## Value

list(disc, test): votes tables (rows with no votes dropped)
