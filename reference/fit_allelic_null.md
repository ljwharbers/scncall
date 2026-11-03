# Beta-binomial overdispersion of the null allele votes

[`fit_bb_rho()`](https://ljwharbers.github.io/scphasedcn/reference/fit_bb_rho.md)
(balanced, f = 0.5) on the rows with `n > 0`.

## Usage

``` r
fit_allelic_null(nA, n, by = NULL)
```

## Arguments

- nA:

  votes for haplotype A (oriented)

- n:

  total votes

- by:

  NULL (one rho) or grouping: a vector with one label per row, or a list
  / data.table of such vectors

## Value

rho (numeric) when `by` is NULL; else data.table with the group columns
(`group` for an unnamed vector), `rho` and `n_rows` (rows with n \> 0;
rho NA for a group without any)
