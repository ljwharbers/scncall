# Orient phase blocks by a leave-one-out pseudobulk

Per region and phase set, the pseudobulk votes of the cell's group (all
cells for a cell with NA group or when `groups` is NULL) minus the
cell's own votes (`loo = TRUE`) decide the block's orientation: tied
blocks are dropped, blocks with `rA < rB` are flipped, and the oriented
votes are summed per cell and region. Region membership: molecule (atom)
start inside `[start, end)`.

## Usage

``` r
orient_blocks(votes, regions, atoms, groups = NULL, loo = TRUE)
```

## Arguments

- votes:

  votes table
  ([`read_votes()`](https://ljwharbers.github.io/scphasedcn/reference/read_votes.md))

- regions:

  regions table

- atoms:

  atoms table

- groups:

  NULL or one group label per cell (indexed by the votes' `cell`; NA =
  all-cell pseudobulk)

- loo:

  leave the cell's own votes out of the pseudobulk

## Value

data.table `cell, region, nA, nB, n_blocks` (rows with at least one
non-tied block)
