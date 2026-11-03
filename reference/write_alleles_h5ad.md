# Write the allele counts as `alleles_dna.h5ad` (layers AD, DP; var = SNPs)

Write the allele counts as `alleles_dna.h5ad` (layers AD, DP; var =
SNPs)

## Usage

``` r
write_alleles_h5ad(alleles, cells, file)
```

## Arguments

- alleles:

  list(AD, DP, snps) (snps x cells matrices)

- cells:

  data.table with a `cell` column (same order as the matrix columns)

- file:

  output path
