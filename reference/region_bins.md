# Bins overlapping a set of regions

Bins overlapping a set of regions

## Usage

``` r
region_bins(bins, regions)
```

## Arguments

- bins:

  data.table with chrom, start, end

- regions:

  data.table from
  [`parse_region()`](https://ljwharbers.github.io/scphasedcn/reference/parse_region.md)
  (NA end = to chromosome end)

## Value

list (one per region) of integer bin indices
