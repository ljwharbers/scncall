# Control regions of a tumour: pieces neutral in every clone

The automatic tumour null: the pieces
([`segment_pieces()`](https://ljwharbers.github.io/scphasedcn/reference/segment_pieces.md))
that are neutral in every clone and at least `min_len` long.
User-supplied control regions override these in
[`caller_tumour()`](https://ljwharbers.github.io/scphasedcn/reference/caller_tumour.md).

## Usage

``` r
control_regions(segments, min_len = 2e+07, regions = NULL)
```

## Arguments

- segments:

  segments table

- min_len:

  minimal piece length (bp)

- regions:

  optional regions table (for sd_class / allelic_ok)

## Value

regions table (class `segment`, names `seg|control|...`)
