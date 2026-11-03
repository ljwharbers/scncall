# Resolve chromosome-level gains against depth and nested calls

A diluted sub-chromosomal imbalance (a 1p loss, a distal CN-LOH) makes
the whole chromosome look like a 2:1 gain: at chromosome scale the
allelic term of the nested event dominates while its depth contrast is
diluted, and the gain state (f 2/3) fits a diluted haplotype fraction
better than 1:0 / 2:0. Per cell, a reportable `gain` call of a `classes`
region therefore needs

1.  depth support: the gain depth LLR of the row itself is positive
    (`dl_gain > min_dl_gain`; for the Student-t null, z above the
    midpoint between neutral and the gain shift), so the allelic term
    alone cannot carry a gain label; and

2.  (class `chrom`) no nested explanation: no called loss / CN-LOH row
    of the same cell and chromosome in `nested` classes (arm, 50 Mb, 20
    Mb) with a higher score. A gain failing either rule stays in the
    table with `called = TRUE` but `reportable = FALSE` and `resolved`
    naming the reason (`no_depth`, `nested <region> <state>`). With
    `promote`, the best (highest-score) nested loss / CN-LOH call that
    explains a dropped chromosome gain is made reportable
    (`resolved = "replaces <region> gain"`; arm and 50 Mb losses are
    reportable anyway, a 20 Mb one is promoted).

## Usage

``` r
resolve_nested(
  calls,
  scores = NULL,
  min_dl_gain = 0,
  classes = c("chrom", "event"),
  nested = c("arm", "50Mb", "20Mb"),
  promote = TRUE
)
```

## Arguments

- calls:

  cell-level calls table
  ([`call_table()`](https://ljwharbers.github.io/scphasedcn/reference/call_table.md))

- scores:

  scored rows (`cell`, `region`, `dl_gain`); NULL when `calls` has
  `dl_gain`

- min_dl_gain:

  minimal gain depth LLR of a reportable gain

- classes:

  classes whose reportable gains need depth support

- nested:

  classes of the nested calls that can explain a chromosome gain

- promote:

  make the explaining nested call reportable

## Value

`calls` with column `resolved` (NA = unchanged) and updated `reportable`
