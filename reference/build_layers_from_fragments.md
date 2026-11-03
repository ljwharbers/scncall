# Build the bin-level layers from a fragment table

Counts fragments by the bin of their start, spans, fragment-length
classes, haplotype layers from the fragment `hap` column, and the obsm
histograms (fragment length, MAPQ) in the Python extraction layout. Used
by the simulator.

## Usage

``` r
build_layers_from_fragments(
  fr,
  bins,
  n_cells,
  cell_index = fr$cell,
  fraglen_breaks = c(0, 200, 300, 500, 750, 1000, 2000, 5000, 10000, Inf)
)
```

## Arguments

- fr:

  data.table with chrom, start, end, cell (integer index or factor), hap
  (optional; "U"/"A"/"B"/"N" or the integer codes), mapq (optional), bin
  (optional; else located from start)

- bins:

  bins table

- n_cells:

  number of cells (columns)

- cell_index:

  integer cell index per fragment (1..n_cells)

- fraglen_breaks:

  fragment-length histogram breaks (Python layout)

## Value

list(counts, layers, obsm)
