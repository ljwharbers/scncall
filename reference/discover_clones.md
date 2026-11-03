# Discover clone leaves: smoothed PCA + Ward tree over-cut

`irlba` PCA of the centred feature matrix, kNN smoothing of the PCs
(mean over each cell and its `k` neighbours, FNN), Ward.D2 `hclust` on
the smoothed PCs, cut at `max_leaves`; leaves smaller than `min_size`
are merged into the nearest leaf (centroid distance). The leaves
over-split on purpose;
[`merge_clones()`](https://ljwharbers.github.io/scphasedcn/reference/merge_clones.md)
merges them back with a calibrated test.

## Usage

``` r
discover_clones(X, n_pc = 20, k = 20, max_leaves = 40, min_size = 20, seed = 1)
```

## Arguments

- X:

  cells x features matrix
  ([`clone_feature_matrix()`](https://ljwharbers.github.io/scphasedcn/reference/clone_feature_matrix.md))

- n_pc:

  principal components

- k:

  neighbours for the smoothing

- max_leaves:

  leaves of the over-cut

- min_size:

  minimal leaf size (cells)

- seed:

  RNG seed

## Value

list(tree = hclust, leaves = named integer labels (names = cells), pc,
smooth)
