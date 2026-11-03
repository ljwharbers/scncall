# Multiplet table of the caller

Normalises the forms a multiplet flag comes in to a table `cell, prob`:
a character vector (or a file with one cell per line) of flagged cells
(prob 1); a table with `prob` (kept); with a logical `multiplet` column
(prob 1 / 0); with a logical `clean_singlet` column (e.g. a multiplet
scorer's table: prob 0 for clean singlets, 1 otherwise); any other table
(prob 1 for every listed cell).

## Usage

``` r
multiplet_table(x)
```

## Arguments

- x:

  NULL, a vector, a path or a table

## Value

data.table cell, prob (NULL for NULL input)
