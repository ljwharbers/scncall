# Per-row rho from a [`rho_by_chrom()`](https://ljwharbers.github.io/scphasedcn/reference/rho_by_chrom.md) table (the global rho where the chromosome has none)

Per-row rho from a
[`rho_by_chrom()`](https://ljwharbers.github.io/scphasedcn/reference/rho_by_chrom.md)
table (the global rho where the chromosome has none)

## Usage

``` r
rho_rows(d, tab, rho)
```

## Arguments

- d:

  rows with `chrom` (or a parsable `region`)

- tab:

  [`rho_by_chrom()`](https://ljwharbers.github.io/scphasedcn/reference/rho_by_chrom.md)
  output

- rho:

  global rho

## Value

numeric vector, one per row
