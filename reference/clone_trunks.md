# Trunks of a clone set

Groups clones that share their clonal events: complete-linkage
clustering of
[`clone_state_distance()`](https://ljwharbers.github.io/scphasedcn/reference/clone_state_distance.md)
cut at `max_dist` bp (two clones of one trunk differ allelically on less
than `max_dist` of the genome). Trunks are the units of block
orientation for within-trunk clone discovery (subclonal events of 5-25 %
of a trunk are oriented far better by the trunk's pseudobulk than by all
cells) and of the doublet hypotheses (mixtures of clones within a trunk
are not scored).

## Usage

``` r
clone_trunks(segments, max_dist = 5e+07, ...)
```

## Arguments

- segments:

  segments table

- max_dist:

  cut height (bp)

- ...:

  passed to
  [`clone_state_distance()`](https://ljwharbers.github.io/scphasedcn/reference/clone_state_distance.md)

## Value

named character vector clone -\> trunk id (`T1`, `T2`, ...)
