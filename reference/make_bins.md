# Tile chromosomes into fixed-width bins

Tile chromosomes into fixed-width bins

## Usage

``` r
make_bins(chrom_sizes, bin_size = 1e+05)
```

## Arguments

- chrom_sizes:

  named numeric vector (bp)

- bin_size:

  bin width (bp); the last bin of a chromosome is truncated

## Value

data.table bin_id, chrom, start, end (0-based half-open)
