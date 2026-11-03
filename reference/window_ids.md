# Window id per bin for aggregation to a coarser grid

Window id per bin for aggregation to a coarser grid

## Usage

``` r
window_ids(bins, size = 1e+06)
```

## Arguments

- bins:

  bins table

- size:

  window size in bp; or "arm" for chromosome arms; or "chrom"

## Value

character window id per bin (NA for bins without an arm when size =
"arm")
