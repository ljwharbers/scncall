# Cross-validation folds of cells

Random, balanced folds over cells (or over their origins: spiked copies
inherit the fold of the cell they were made from, so a copy and its
original are never in different folds).

## Usage

``` r
assign_folds(cells, n_folds = 4, seed = 1, origin = NULL)
```

## Arguments

- cells:

  cell ids (may repeat, e.g. one per row)

- n_folds:

  number of folds

- seed:

  RNG seed

- origin:

  optional origin id per entry of `cells`

## Value

integer fold (1..n_folds) per entry of `cells`
