# Chromosome sizes from a FASTA index (.fai)

Chromosome sizes from a FASTA index (.fai)

## Usage

``` r
read_chrom_sizes(fai, chroms = paste0("chr", c(1:22, "X", "Y")))
```

## Arguments

- fai:

  path to `genome.fa.fai` (or the FASTA; `.fai` is appended)

- chroms:

  chromosomes to keep (default chr1-22, X, Y)

## Value

named numeric vector
