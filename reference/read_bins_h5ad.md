# Read `bins_100kb.h5ad` into an scn object (missing layers tolerated)

Read `bins_100kb.h5ad` into an scn object (missing layers tolerated)

## Usage

``` r
read_bins_h5ad(file, layers = NULL, cells = NULL)
```

## Arguments

- file:

  path

- layers:

  layers to read (default: all present)

- cells:

  optional character vector of cells to keep

## Value

scn object
