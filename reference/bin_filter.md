# Usable-bin flag

Drops centromeric bins, bins with high blacklist / TRF fraction, extreme
or missing GC and (optionally) bins with too low pseudobulk coverage.

## Usage

``` r
bin_filter(
  bins,
  counts = NULL,
  max_blacklist = 0.1,
  max_trf = 0.2,
  gc_range = c(0.3, 0.65),
  min_cov_frac = 0.1,
  chroms = NULL
)
```

## Arguments

- bins:

  bins table

- counts:

  optional bins x cells matrix for the coverage filter

- max_blacklist, max_trf:

  fraction thresholds

- gc_range:

  allowed GC range

- min_cov_frac:

  pseudobulk coverage must exceed this fraction of the median

- chroms:

  chromosomes to keep (NULL = all)

## Value

logical vector `use`
