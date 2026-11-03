# Region x bin indicator under the depth (containment) rule

Row r marks the bins of region r's chromosome with
`bin.start >= start & bin.end <= end` (NA end = chromosome end),
restricted to `use`.

## Usage

``` r
region_bin_matrix(bins, regions, use = NULL)
```

## Arguments

- bins:

  bins table

- regions:

  regions table (`region, chrom, start, end`)

- use:

  logical bin filter (NULL = all bins)

## Value

sparse regions x bins dgCMatrix (row names = region names)
