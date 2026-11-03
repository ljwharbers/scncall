# Allele features per cell and region

Votes summed per cell and region (molecule start inside the region)
after orienting the phase blocks: `chromosome` = plain sums
(chromosome-wide anchored phase; `orient = "anchored"`); `loo` =
[`orient_blocks()`](https://ljwharbers.github.io/scphasedcn/reference/orient_blocks.md)
(`orient = "pseudobulk"` without groups, `"clone"` with groups);
`mirrored` = block orientation marginalised ( `f` = the grid MLE
`f_mirror`, `nA` / `nB` = the block-wise majority / minority votes;
`orient = "none"`); `auto` = `chromosome` when
[`detect_phasing()`](https://ljwharbers.github.io/scphasedcn/reference/detect_phasing.md)
finds chromosome-wide phase sets, else `loo`. Regions with
`allelic_ok = FALSE` are skipped.

## Usage

``` r
allelic_features(
  votes,
  atoms,
  regions,
  orientation = c("auto", "chromosome", "loo", "mirrored"),
  groups = NULL,
  rho = NULL,
  params = caller_defaults(),
  exclude_atoms = NULL
)
```

## Arguments

- votes:

  votes table

- atoms:

  atoms table

- regions:

  regions table

- orientation:

  "auto", "chromosome", "loo" or "mirrored"

- groups:

  NULL or one group label per cell (see
  [`orient_blocks()`](https://ljwharbers.github.io/scphasedcn/reference/orient_blocks.md))

- rho:

  beta-binomial overdispersion for `mirrored` (NULL: fitted on the
  blocks of null regions with at least 2 votes, at most 2e6 seeded rows)

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)
  (`eps`, `seed`)

- exclude_atoms:

  NULL or atom ids whose votes are dropped before the region sums (an
  allelic mask of overdispersed tiles,
  [`allelic_noisy_tiles()`](https://ljwharbers.github.io/scphasedcn/reference/allelic_noisy_tiles.md));
  orientation and block logic are otherwise unchanged

## Value

data.table `cell` (index), `region, nA, nB, n_hap, n_blocks, f, orient`;
attribute `rho` for mirrored
