# Tile region name

`<label>|<window id>` with the window id of
[`window_ids()`](https://ljwharbers.github.io/scphasedcn/reference/window_ids.md)
(`chrom:start`, start as a plain integer), e.g. `"5Mb|chr1:0"`.

## Usage

``` r
tile_name(label, chrom, start)
```

## Arguments

- label:

  tile size label ("5Mb", "10Mb", "20Mb", "50Mb")

- chrom:

  chromosome

- start:

  tile start (bp, 0-based)

## Value

character vector
