# High-pass-filtered chromatin embedding (kNN neighbourhoods of the caller)

High-pass-filtered chromatin embedding (kNN neighbourhoods of the
caller)

## Usage

``` r
chromatin_embedding(X, s, bins, hp_window = 21, n_pc = 20)
```

## Arguments

- X:

  used bins x cells counts

- s:

  size factors

- bins:

  used bins table

- hp_window:

  running-median window (bins)

- n_pc:

  number of PCs

## Value

cells x n_pc score matrix
