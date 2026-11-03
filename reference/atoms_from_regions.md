# Allele atoms

The smallest genomic units votes are counted in: the bins of the
regions' chromosomes, split at every region start / end that is not a
bin boundary, so that "molecule start inside a region" is "atom inside
the region" for every region.

## Usage

``` r
atoms_from_regions(bins, regions)
```

## Arguments

- bins:

  bins table

- regions:

  regions table (`chrom, start, end`)

## Value

data.table `atom, chrom, start, end, bin` (bin = row of `bins`; passes
[`check_atoms()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))
