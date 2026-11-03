# Vote strata: bins of the allele votes per class x depth stratum

Under the null the allelic LLR of a fixed gain fraction f is linear in
nA: its mean is about `n_hap x 0.5 log(4 f (1 - f))` and its spread
grows with sqrt(n_hap), so one null quantile per class is set by the
vote-rich regions (large chromosomes) and is too loose for vote-poor
ones (small chromosomes such as chr21 carry several times fewer votes
than chr1). Thresholds keyed on class x stratum x `hstratum` (bins of
n_hap) pool regions with similar vote counts instead of estimating one
threshold per region.

## Usage

``` r
vote_bins(
  d,
  n_bins = params$vote_bins,
  min_null = params$min_null_rows,
  null = NULL,
  params = caller_defaults()
)
```

## Arguments

- d:

  rows with `class`, `stratum`, `n_hap` and a null definition
  ([`budget_thresholds()`](https://ljwharbers.github.io/scphasedcn/reference/budget_thresholds.md))

- n_bins:

  maximal bins per class x stratum (`params$vote_bins`)

- min_null:

  minimal null rows per bin (`params$min_null_rows`)

- null:

  optional logical null flag per row

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)

## Value

data.table class, stratum, hstratum, lo, hi, n_null (null rows with
votes in the class x stratum)

## Details

Per class x stratum, the null rows with votes (`n_hap > 0`) are cut at
their type-7 quantiles into
`k = max(1, min(n_bins, floor(n / min_null)))` bins of (nearly) equal
size, so a bin keeps `min_null` null rows. Bin i covers
`lo < n_hap <= hi`.
[`assign_hstratum()`](https://ljwharbers.github.io/scphasedcn/reference/assign_hstratum.md)
labels rows `h1`..`hk`, `none` (no votes) or `all` (a class x stratum
without bins).
