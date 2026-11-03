# Atoms whose start lies in the masked tiles

Atoms whose start lies in the masked tiles

## Usage

``` r
atoms_in_tiles(atoms, tiles)
```

## Arguments

- atoms:

  atoms table (atom, chrom, start, end)

- tiles:

  [`allelic_noisy_tiles()`](https://ljwharbers.github.io/scphasedcn/reference/allelic_noisy_tiles.md)
  output (rows with `masked`), or any table with chrom, start, end

## Value

integer atom ids
