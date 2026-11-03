# Fit the beta-binomial overdispersion on balanced (flat) counts

Fit the beta-binomial overdispersion on balanced (flat) counts

## Usage

``` r
fit_bb_rho(a, n, f = 0.5)
```

## Arguments

- a:

  hap-A counts

- n:

  totals

- f:

  mean (0.5 for flat cells)

## Value

rho (MLE between 1e-4 and 0.5)
