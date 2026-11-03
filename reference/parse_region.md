# Parse a region string "chr20:28000000-" or "chr5" into a data.table

Parse a region string "chr20:28000000-" or "chr5" into a data.table

## Usage

``` r
parse_region(x, chrom_sizes = NULL)
```

## Arguments

- x:

  character vector of regions (`chrom`, `chrom:start-end`,
  `chrom:start-`)

- chrom_sizes:

  optional named integer vector to fill open ends

## Value

data.table with columns region, chrom, start, end (0-based half-open; NA
end = chromosome end)
