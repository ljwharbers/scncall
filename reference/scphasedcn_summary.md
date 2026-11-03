# Headline numbers of a caller result

Headline numbers of a caller result

## Usage

``` r
scphasedcn_summary(obj)
```

## Arguments

- obj:

  `scphasedcn`

## Value

data.table section, item, value, n (denominator or count), note.
Sections: `cells` (cells, null cells, multiplets, cells with a
reportable call / event), `calls` (called cell / pool / clone rows per
level, class and state; `n` = reportable among them), `false_calls`
(null false calls per 1,000 per class over all strata; `n` = null rows),
`false_events` (false autosomal arm calls per null cell, any state and
per state), `events` (reportable events per cell and per null cell,
pooled calls), `clones` (clones, assigned cells, reference pool).
