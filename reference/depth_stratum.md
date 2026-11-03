# Depth stratum of a cell

Strata on clean fragments per cell:
`cut(n, c(-Inf, breaks, Inf), right = FALSE)`, so a cell with exactly
20,000 fragments is in `20-50k`.

## Usage

``` r
depth_stratum(n, breaks = caller_defaults()$strata_breaks, labels = NULL)
```

## Arguments

- n:

  clean fragments per cell

- breaks:

  interior breaks (default `caller_defaults()$strata_breaks`)

- labels:

  stratum labels (length(breaks) + 1); generated as `<a`, `a-b`, `>=b`
  (in thousands) when NULL

## Value

factor
