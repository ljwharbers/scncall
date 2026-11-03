# Clone pseudobulk profiles

Per clone x window (1 Mb, or `size`): depth log2 of the pooled counts
(`log2((sum x + 0.5) / (sum e + 0.5))`), relative to the clean reference
pool's pseudobulk when `ref_cells` has \>= `min_ref` cells, then centred
on the clone's autosomal median (states are relative to the clone
baseline); SE = SD of the per-cell window log2 ratios / sqrt(cells)
(combined with the reference SE). Haplotype fraction: the clone's cells
are split into two random halves; each phase block is oriented on one
half and counted on the other, summed per window: `nA`, `nB`, `n_hap`,
`f`, `f_se` (binomial SE x the beta-binomial inflation
`1 + (nbar - 1) * rho`, nbar = molecule-weighted molecules per cell),
and `n_blocks`.

## Usage

``` r
clone_profiles(
  win,
  votes,
  atoms,
  assign,
  ref_cells = NULL,
  size = 1e+06,
  seed = 1,
  cells = colnames(win$x),
  rho = 0.01,
  allelic_chroms = NULL,
  haploid = character(),
  min_ref = 30
)
```

## Arguments

- win:

  1 Mb window depth: list(windows (window, chrom, start, end), x, e)
  with x / e windows x cells

- votes, atoms:

  votes and atoms tables

- assign:

  data.table cell, clone (cells used for each clone's pseudobulk)

- ref_cells:

  reference pool cells (NULL = none)

- size:

  window size (bp; a multiple of 1 Mb), one value or one per clone
  (named)

- seed:

  RNG seed of the split halves

- cells:

  cell names in vote index order (default the columns of `win$x`)

- rho:

  beta-binomial overdispersion

- allelic_chroms:

  chromosomes with an allele channel (NULL = all)

- haploid:

  chromosomes with one copy in a normal cell (male chrX / chrY):
  `ploidy` 1

- min_ref:

  minimal reference pool size

## Value

data.table clone, window, chrom, start, end, ploidy, base (copy number
of log2 = 0: the ploidy when relative to the pool, else 2), n_cells,
log2, log2_se, nA, nB, n_hap, f, f_se, n_blocks, ref ("pool" or
"median"), size
