# Collapse fragments into molecules

Fragments with haplotype A or B, sorted by cell, chromosome and start; a
new molecule starts when `start > cummax(end) + gap` of the previous
fragments of the same cell and chromosome; one vote per molecule for the
majority haplotype (ties dropped); `ps` is the first fragment's phase
set. The running maximum is computed per group with an integer offset
(exact for coordinates below 2^53 / number of groups).

## Usage

``` r
collapse_molecules(fr, gap = 2000)
```

## Arguments

- fr:

  fragments with `cell, chrom, start, end, hap, ps`; `hap` "A"/"B"
  (other labels dropped) or integer codes 1 / 2 (= A / B)

- gap:

  maximal gap (bp) between fragments of one molecule

## Value

data.table `cell, chrom, start, end, ps, n_frag, hap` (hap "A"/"B"), one
row per molecule
