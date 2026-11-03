# Chromosome arms and centromere flags from the Battenberg coordinate table

Chromosome arms and centromere flags from the Battenberg coordinate
table

## Usage

``` r
annotate_arms(bins, centromeres = hg38_centromeres(), pad = 1e+06)
```

## Arguments

- bins:

  bins table

- centromeres:

  path to `chromosome_coordinates_hg38_chr.txt` (columns chr, start,
  cen.left.base, cen.right.base, end) or a data.table; chrX / chrY may
  be named `chr23` / `chr24` (as in the Battenberg table)

- pad:

  bp around the centromere flagged as centromeric

## Value

bins with columns arm ("p"/"q"), is_centromere
