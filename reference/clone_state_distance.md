# Allelic state distance between clones

Base pairs of the shared pieces
([`segment_pieces()`](https://ljwharbers.github.io/scphasedcn/reference/segment_pieces.md))
on which two clones' states differ in their major-haplotype fraction by
at least `min_df` (e.g. 1:1 vs 2:1, 1:0 vs 2:1) or in total copy number
by at least `min_dcn`. Depth-only differences of one copy between
amplified states (4:0 vs 3:0) do not count: a cell between two such
clones is fitted better by their mixture than by either clone, which is
not evidence of a doublet.

## Usage

``` r
clone_state_distance(segments, min_df = 0.15, min_dcn = 2, min_len = 5e+06)
```

## Arguments

- segments:

  segments table

- min_df:

  minimal difference of the state major fractions

- min_dcn:

  minimal total copy-number difference that counts on its own

- min_len:

  pieces shorter than this are ignored

## Value

symmetric numeric matrix clones x clones (bp)
