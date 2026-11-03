# Merge over-split clone leaves with a permutation-calibrated split test

Bottom-up: each round, every clone's `n_nb` nearest clones (Ward
distance between the clones' centroids in the smoothed PC space) are
candidate pairs; the pairs are tested in order of distance with the
clone contrast (`split_test`) against the `q`-quantile of the same
statistic on random splits of the pooled pair at matching sizes
(`n_perm` permutations, sequential early stop), and non-different pairs
are merged (each clone at most once per round). Stops when every
candidate pair of the remaining clones differs at the budget
(`q = 0.999` = 1 false split per 1,000 tests). Each half is subsampled
to `max_cells` cells (observed and null alike). Nearest neighbours
rather than Ward siblings only: once two sibling clones differ, a
sibling-only rule never compares either of them with any other clone.

## Usage

``` r
merge_clones(
  feat_long,
  votes,
  atoms,
  regions,
  leaves,
  tree,
  q = 0.999,
  n_perm = 200,
  seed = 1,
  rho = 0.01,
  classes = c("arm", "20Mb"),
  cells = NULL,
  max_cells = 250,
  cdata = NULL,
  depth_delta = 0.2,
  n_nb = 3
)
```

## Arguments

- feat_long:

  features long table

- votes, atoms, regions:

  votes, atoms, regions

- leaves:

  named leaf labels (names = cells), from
  [`discover_clones()`](https://ljwharbers.github.io/scphasedcn/reference/discover_clones.md)

- tree:

  the
  [`discover_clones()`](https://ljwharbers.github.io/scphasedcn/reference/discover_clones.md)
  result (its `smooth` coordinates are used) or a cells x dims matrix

- q:

  null quantile (budget)

- n_perm:

  permutations per test

- seed:

  RNG seed

- rho:

  beta-binomial overdispersion

- classes:

  region classes of the contrast

- cells:

  cell names in vote index order

- max_cells:

  subsample per half

- cdata:

  optional pre-computed
  [`contrast_data()`](https://ljwharbers.github.io/scphasedcn/reference/contrast_data.md)

- depth_delta:

  minimal depth effect (log2) of the contrast

- n_nb:

  nearest clones tested per clone and round

## Value

list(clones = named integer labels, tests = data.table of all tests)
