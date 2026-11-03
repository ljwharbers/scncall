# Aggregation matrix mapping rows (bins) to groups

Aggregation matrix mapping rows (bins) to groups

## Usage

``` r
group_indicator(groups)
```

## Arguments

- groups:

  integer/character group id per row (NA = dropped)

## Value

sparse groups x rows indicator matrix (dgCMatrix) with group labels as
rownames
