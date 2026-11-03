# Consolidate nested calls into events

Per cell (or pool / clone) x chromosome x state, called regions nested
in a larger called region of the same state are merged into it (the
largest called region, ties to the higher score); overlapping but not
nested calls stay separate events.

## Usage

``` r
consolidate_calls(calls, regions = NULL, reportable_only = TRUE)
```

## Arguments

- calls:

  calls table
  ([`call_table()`](https://ljwharbers.github.io/scphasedcn/reference/call_table.md),
  [`call_pools()`](https://ljwharbers.github.io/scphasedcn/reference/call_pools.md))

- regions:

  optional regions table to fill missing coordinates

- reportable_only:

  only reportable calls

## Value

data.table cell, chrom, start, end, state, top_region, score, level,
top_class, n_regions
