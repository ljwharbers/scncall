# Allelically overdispersed tiles (data-driven allelic mask)

Per tile of class `size`, the method-of-moments beta-binomial
overdispersion of the null rows' allele votes,
`rho = (sum (nA - n/2)^2 - sum n/4) / sum n (n - 1) / 4`, then `z_rho` =
(log rho - median) / MAD of log rho over the tiles with at least
`min_votes` votes per null row. Tiles with `z_rho > k_mad` are masked: a
local stretch whose votes are far more overdispersed than the genome
(e.g. a 5 Mb tile with rho 0.040 vs a genome median of 0.011 over 5 Mb
tiles) and that inflates the chromosome-level allelic LLRs of the cells.
The votes of the atoms in masked tiles
([`atoms_in_tiles()`](https://ljwharbers.github.io/scphasedcn/reference/atoms_in_tiles.md))
are then left out of the allele features
([`update_allelic_features()`](https://ljwharbers.github.io/scphasedcn/reference/update_allelic_features.md),
`call_scn(params$mask_allelic = TRUE)`).

## Usage

``` r
allelic_noisy_tiles(
  feat_long,
  null = NULL,
  size = "5Mb",
  k_mad = params$mask_rho_mad,
  min_votes = params$mask_min_votes,
  params = caller_defaults()
)
```

## Arguments

- feat_long:

  features long table (class, region, chrom, nA, n_hap) with a null
  definition

- null:

  optional logical null flag per row

- size:

  tile class

- k_mad:

  threshold in MADs of log rho (`params$mask_rho_mad`)

- min_votes:

  minimal mean votes per null row of a tile for it to be assessed
  (`params$mask_min_votes`)

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)

## Value

data.table tile, chrom, start, end, n_rows, votes, rho, z_rho, assessed,
masked (one row per tile)
