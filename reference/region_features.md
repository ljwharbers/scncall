# Per-cell depth features on arbitrary regions

Sums the 1 Mb window counts (`win`) of the windows inside each region
(window start \>= region start and window end \<= region end) and
returns the feature columns of the long features table: x, e, log2ratio,
sd_null (the cell's `sd_null` of the region's `sd_class` from the run's
features; the nearest available class when missing), z, stratum, n_frag.
For regions that are not in the feature table (clone pieces and
segments, MEDICC2 pieces). No allelic columns: the callers score those
with a clone-specific orientation.

## Usage

``` r
region_features(
  feat,
  regs,
  cells = NULL,
  sd_floor = caller_defaults()$sd_floor
)
```

## Arguments

- feat:

  scn_features list (or `clone_input`) with the 1 Mb window depth `win`

- regs:

  regions table (region, chrom, start, end, class, sd_class)

- cells:

  cells to compute (default all)

- sd_floor:

  floor of sd_null

## Value

features long table: cell, region, x, e, class, sd_class, chrom,
log2ratio, sd_null, z, n_frag, stratum
