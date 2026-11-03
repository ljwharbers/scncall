# Construct an scn object

Construct an scn object

## Usage

``` r
new_scn(
  counts,
  bins,
  cells,
  layers = list(),
  obsm = list(),
  uns = list(),
  alleles = NULL,
  fragments = NULL
)
```

## Arguments

- counts:

  bins x cells matrix (coerced to dgCMatrix)

- bins:

  data.table of bins (chrom, start, end, ...)

- cells:

  data.table of cells (column `cell` first)

- layers:

  named list of bins x cells matrices (same dims as counts)

- obsm:

  named list of cells x k matrices

- uns:

  list of unstructured metadata

- alleles:

  NULL or list(AD, DP (snps x cells dgCMatrix), snps data.table)

- fragments:

  NULL, a path to fragments.tsv.gz, or a data.table

## Value

object of class `scn`
