# Beta-binomial log-likelihood

Beta-binomial log-likelihood

## Usage

``` r
bb_loglik(a, n, f, rho = 0.02, eps = 0.02)
```

## Arguments

- a:

  successes (hap-A counts)

- n:

  trials

- f:

  mean

- rho:

  overdispersion between 0 and 1; 0 = binomial

- eps:

  floor/ceiling applied to f (allele error)

## Value

log-likelihood vector
