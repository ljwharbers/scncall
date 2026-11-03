# Robust overdispersion of null allele votes

Median-based estimate of the beta-binomial rho that tolerates a minority
of imbalanced rows (events in a not yet cleaned null set): with
`zj = (nA + U - 1/2 - n/2) / sqrt(n/4)` (U uniform jitter, seeded) the
variance is `1 + (n - 1) rho + 1/(3n)`, and rho solves
`median(|zj| / sqrt(1 + (n - 1) rho + 1/(3n))) = qnorm(0.75)`. The MLE
([`fit_allelic_null()`](https://ljwharbers.github.io/scphasedcn/reference/fit_allelic_null.md))
is used for the final null; this one only seeds the null-cell selection.

## Usage

``` r
robust_rho(nA, n, min_n = 30, seed = 1)
```

## Arguments

- nA:

  votes for haplotype A

- n:

  total votes

- min_n:

  rows with fewer votes are ignored (normal approximation)

- seed:

  jitter seed

## Value

rho in `[1e-4, 0.5]`; the MLE when fewer than 50 rows have `n >= min_n`
