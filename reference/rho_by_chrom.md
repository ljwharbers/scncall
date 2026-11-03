# Per-chromosome allelic overdispersion, shrunk to the global

The beta-binomial rho of the null allele votes can differ between
chromosomes (small chromosomes up to about twice the genome-wide value),
so one global rho under-penalises the allelic tails of the more
overdispersed ones. Per chromosome, rho is fitted
([`fit_allelic_null()`](https://ljwharbers.github.io/scphasedcn/reference/fit_allelic_null.md))
on the null rows of `classes` (default the arms, as the global rho) and
shrunk to the global:
`rho_c = (n x rho_raw + k x rho_global) / (n + k)`, n = null rows with
votes. Chromosomes without null rows (chrX in normal mode) keep the
global rho
([`rho_rows()`](https://ljwharbers.github.io/scphasedcn/reference/rho_rows.md)).

## Usage

``` r
rho_by_chrom(
  d,
  rho = NULL,
  k = params$rho_chrom_k,
  null = NULL,
  classes = "arm",
  params = caller_defaults()
)
```

## Arguments

- d:

  rows with `nA`, `n_hap`, `class`, `chrom` (or a parsable `region`) and
  a null definition

- rho:

  global rho (NULL: fitted on the same rows)

- k:

  shrinkage pseudo-count (null rows; `params$rho_chrom_k`)

- null:

  optional logical null flag per row

- classes:

  region classes of the fit

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)

## Value

data.table chrom, n_rows, rho_raw, rho_global, w (= n / (n + k)), rho
