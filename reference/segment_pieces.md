# Pieces: the union of all clone segment breakpoints

Per chromosome, every segment start / end of every clone is a
breakpoint; the pieces between adjacent breakpoints are regions of class
`segment` named `seg|<tag>|chrom:start-end`.

## Usage

``` r
segment_pieces(segments, regions = NULL, tag = "all")
```

## Arguments

- segments:

  segments table

- regions:

  regions table of the run (for `sd_class`, n_bins, allelic_ok)

- tag:

  clone field of the region name ("all" for the shared pieces)

## Value

regions table
([`check_regions()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))
of the pieces
