# Write a fragments table as bgzipped TSV with a tabix index

Columns written: chrom start end cell strand mapq flags (+ any extra
columns present, e.g. hap, n_snps). The header line starts with `#` so
tabix skips it.

## Usage

``` r
write_fragments(fr, file, extra = NULL)
```

## Arguments

- fr:

  data.table

- file:

  output path ending in `.tsv.gz`

- extra:

  extra columns to keep (default: any beyond the contract)

## Value

path
