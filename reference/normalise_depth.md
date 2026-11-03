# Normalise read depth against a reference

Expected counts per bin and cell, and the log2 ratio of observed to
expected (centred per cell). Every reference of a cell leaves that cell
out.

- `loo`: the pseudobulk of all other reference cells.

- `celltype`: the pseudobulk of the other reference cells of the same
  cell type; cells without a type, and types with fewer than
  `min_cells_type` reference cells, use `loo`. The normal-tissue
  reference: it removes the cell-type-specific chromatin signal in the
  depth.

- `model`: a robust Poisson GLM of the bin counts on GC content,
  mappability proxies and peak coverage, plus a per-cell GC trend. The
  tumour reference: it needs no copy-number-normal cells.

## Usage

``` r
normalise_depth(
  scn,
  method = "loo",
  use = NULL,
  cell_type = NULL,
  ref_cells = NULL,
  min_cells_type = 20,
  per_cell_gc = TRUE,
  ...
)
```

## Arguments

- scn:

  scn object

- method:

  "loo", "celltype" or "model"

- use:

  logical bin filter (default
  [`bin_filter()`](https://ljwharbers.github.io/scphasedcn/reference/bin_filter.md)
  on bins and counts)

- cell_type:

  cell type per cell (default `scn$cells$cell_type`)

- ref_cells:

  optional selector of cells allowed as references (e.g. clean singlets)

- min_cells_type:

  celltype: types with fewer reference cells fall back to the global
  reference

- per_cell_gc:

  model: subtract a per-cell robust GC trend after the shared GLM

- ...:

  unused

## Value

`scn_norm`: list(method, ratio (bins x cells log2, NA on unused bins),
expected (bins x cells counts, NA on unused bins), use, size, params)
