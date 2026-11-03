# Depth features per cell and region

Observed (`x`) and expected (`e`) fragments of each region's usable bins
(containment rule) by sparse region x bin products,
`log2ratio = log2((x + 0.5) / (e + 0.5))`, `sd_null` = 1.4826 x MAD
(`mad(constant = 1)`) of the cell's `log2ratio` over the null regions
(`null_region`, with a usable bin) whose class is the row's `sd_class`
(tiles: all null tiles of that size), and
`z = log2ratio / pmax(sd_null, sd_floor)`. When the regions table has no
null region of a needed sd_class, the reference regions are built from
the bins of the null chromosomes (arms from `bins$arm`, chromosomes, or
tiles).

## Usage

``` r
depth_features(scn, norm, regions, params = caller_defaults())
```

## Arguments

- scn:

  scn object (counts, bins, cells)

- norm:

  `scn_norm` from
  [`normalise_depth()`](https://ljwharbers.github.io/scphasedcn/reference/normalise_depth.md)
  (expected counts, `use`)

- regions:

  regions table
  ([`region_set()`](https://ljwharbers.github.io/scphasedcn/reference/region_set.md))

- params:

  [`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md)
  (`sd_floor`)

## Value

data.table keyed by `cell, region`: cell, region, class, sd_class,
chrom, x, e, log2ratio, sd_null, z
