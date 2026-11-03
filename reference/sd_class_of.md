# sd_class of a region (which null regions give its per-cell null SD)

Arm, chrom and tile regions use their own class. Any other region
(event, segment) uses, in order: `chrom` if it contains \>= 90 % of its
chromosome's bins; `arm` if it contains \>= 60 % of the bins of one arm;
else the tile size nearest to its length on a log scale. Bins are
counted under the depth (containment) rule over all bins (see
[`region_set()`](https://ljwharbers.github.io/scphasedcn/reference/region_set.md)).

## Usage

``` r
sd_class_of(regions, bins, arms, params = caller_defaults())
```

## Arguments

- regions:

  table with `chrom, start, end` and optionally `class`

- bins:

  bins table

- arms:

  [`arm_table()`](https://ljwharbers.github.io/scphasedcn/reference/arm_table.md)
  output

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)
  (`tile_sizes`)

## Value

character vector
