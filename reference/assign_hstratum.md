# Vote stratum of each row

Vote stratum of each row

## Usage

``` r
assign_hstratum(d, bins)
```

## Arguments

- d:

  rows with `class`, `stratum`, `n_hap`

- bins:

  [`vote_bins()`](https://ljwharbers.github.io/scphasedcn/reference/vote_bins.md)
  output

## Value

character vector: `h<i>` (bin of the row's class x stratum), `none`
(n_hap 0 or NA) or `all` (class x stratum without bins)
