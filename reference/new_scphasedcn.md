# The caller's result object

An S3 list of class `scphasedcn` holding everything one run of the
caller produces. Components that are not NULL are validated with the
matching `check_*` function.

## Usage

``` r
new_scphasedcn(
  mode,
  cells,
  regions,
  features = NULL,
  scores = NULL,
  thresholds = NULL,
  calls = NULL,
  events = NULL,
  pools = NULL,
  clones = NULL,
  assignments = NULL,
  segments = NULL,
  profiles = NULL,
  null_fit = NULL,
  params = caller_defaults(),
  notes = character()
)
```

## Arguments

- mode:

  "normal" (normal tissue: per-cell calls, pooled small events) or
  "tumour" (clone discovery, clone states, cell re-assignment)

- cells:

  character vector of cell barcodes or a data.table with a `cell` column
  (row order defines the integer `cell` index of the votes)

- regions:

  regions table
  ([`check_regions()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))

- features:

  features long table
  ([`check_features()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))

- scores:

  per cell x region x state scores

- thresholds:

  thresholds table
  ([`check_thresholds()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))

- calls:

  calls table
  ([`check_calls()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))

- events:

  called events (the scorer / pipeline)

- pools:

  pool definitions

- clones:

  clone table

- assignments:

  cell-to-clone assignments

- segments:

  clone segments
  ([`check_segments()`](https://ljwharbers.github.io/scphasedcn/reference/check_tables.md))

- profiles:

  per-clone or per-cell profiles (the tumour mode / pipeline)

- null_fit:

  null fits (depth t parameters, allelic rho)

- params:

  parameter list
  ([`caller_defaults()`](https://ljwharbers.github.io/scphasedcn/reference/caller_defaults.md))

- notes:

  character vector of run notes

## Value

object of class `scphasedcn`
