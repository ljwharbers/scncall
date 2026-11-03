# Index of the bin containing each position

Bins must tile each chromosome in order (as produced by
[`make_bins()`](https://ljwharbers.github.io/scphasedcn/reference/make_bins.md)
or the Python extraction layer). Positions outside any bin give NA.

## Usage

``` r
locate_bins(bins, chrom, pos)
```

## Arguments

- bins:

  data.table with chrom, start, end (sorted by chrom then start)

- chrom:

  character vector

- pos:

  numeric vector (0-based)

## Value

integer vector of row indices into `bins`
