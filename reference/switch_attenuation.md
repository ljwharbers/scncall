# Expected attenuation of the anchored imbalance by switch errors

Within a block of k SNPs with per-SNP switch probability p the fraction
of SNPs in the flipped parity state is q = (1/k) sum_j (1 - (1 - 2p)^j)
/ 2, and the anchored deviation \|f - 0.5\| is multiplied by (1 - 2q).

## Usage

``` r
switch_attenuation(switch_rate, n_snps)
```

## Arguments

- switch_rate:

  per-SNP switch probability

- n_snps:

  SNPs per block (vector allowed; the mean factor is returned)

## Value

attenuation factor in (0, 1\]
