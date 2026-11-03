# Chromatin-neighbourhood pools

One pool per cell: the cell and its `k - 1` nearest neighbours
(Euclidean,
[`FNN::get.knn()`](https://rdrr.io/pkg/FNN/man/get.knn.html)) in a
chromatin embedding
([`chromatin_embedding()`](https://ljwharbers.github.io/scphasedcn/reference/chromatin_embedding.md)).
Never build the embedding from copy-number features: pools of cells that
share an event would make the pooled null anti-conservative.

## Usage

``` r
knn_pools(emb, k = 20)
```

## Arguments

- emb:

  cells x components matrix with cell ids as row names

- k:

  pool size (including the centre cell)

## Value

data.table pool, cell, group ("knn"), center
