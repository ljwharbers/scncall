# Minimal regions table from a features table

For callers given only features: `region`, `class`, `sd_class`, `chrom`
and tile coordinates parsed from tile names (`5Mb|chr1:0` -\> 0, 5e6);
arms / chromosomes / events get NA coordinates.

## Usage

``` r
regions_from_features(feat, params = caller_defaults())
```

## Arguments

- feat:

  features long table

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)
  (tile sizes)

## Value

regions table (check_regions schema)
