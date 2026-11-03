# Allelic distance between clones under the all-cell orientation

Clone pseudobulk haplotype fractions per arm with every phase block
oriented by the all-cell pseudobulk (`oc`: per cell x arm counts from
`orient_blocks` without groups, computed once):
`D[k, l] = sum over arms of len x max(|f_k - f_l| - floor, 0)` (bp x
fraction). Events carried by a large share of the cells (trunk events,
e.g. an arm loss in one tumour region, a chromosome lost on opposite
haplotypes in two lineages, a gain in all tumour cells) are oriented
correctly in nearly every block and give large differences; a subclone's
private event is outweighed in the all-cell pseudobulk and contributes
little. This is what makes the distance a trunk distance, unlike the
clone state distance, where sibling clones with one misfitted segment
are as far apart as different lineages.

## Usage

``` r
clone_allelic_distance(oc, members, arms, floor = 0.03, min_mol = 200)
```

## Arguments

- oc:

  data.table cell (name), region (arm), nA, nB: all-cell oriented votes

- members:

  data.table cell, clone

- arms:

  regions table of the arms (region, start, end)

- floor:

  noise floor of \|f_k - f_l\|

- min_mol:

  arms with fewer pooled molecules in a clone are ignored for that
  clone's pairs

## Value

symmetric numeric matrix clones x clones
