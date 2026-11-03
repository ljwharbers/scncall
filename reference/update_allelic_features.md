# Re-aggregate the allele features of a features object without some atoms

Recomputes `nA`, `nB`, `n_hap`, `n_blocks` and `f` of the `allelic_ok`
regions of `features$long` from `features$votes` after dropping the
votes of `exclude_atoms` (an allelic mask,
[`allelic_noisy_tiles()`](https://ljwharbers.github.io/scphasedcn/reference/allelic_noisy_tiles.md)),
with the features' own orientation (`features$phasing["orientation"]`).
The depth columns are untouched.

## Usage

``` r
update_allelic_features(
  features,
  exclude_atoms,
  groups = NULL,
  params = caller_defaults()
)
```

## Arguments

- features:

  `scn_features`
  ([`cell_features()`](https://ljwharbers.github.io/scphasedcn/reference/cell_features.md))
  with `votes` and `atoms`

- exclude_atoms:

  atom ids to leave out

- groups:

  pseudobulk groups of the block orientation (as in
  [`cell_features()`](https://ljwharbers.github.io/scphasedcn/reference/cell_features.md);
  NULL in normal mode)

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)

## Value

the features object with updated allele columns and a note
