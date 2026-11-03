# Validate the caller's tables against their schemas

Each validator stops with a message naming the missing column(s), the
column(s) of the wrong type, or values outside the allowed set, and
returns its input invisibly. Extra columns are allowed. Types: character
(factors are rejected), numeric (integer or double), integer (integer or
whole-number double), logical; an all-NA column passes any type. Schemas
are listed in
[`vignette("scphasedcn-outputs", package = "scphasedcn")`](https://ljwharbers.github.io/scphasedcn/articles/scphasedcn-outputs.md).

## Usage

``` r
check_regions(x)

check_votes(x)

check_atoms(x)

check_features(x)

check_thresholds(x)

check_calls(x)

check_segments(x)
```

## Arguments

- x:

  table to check

## Value

`x`, invisibly

## Functions

- `check_regions()`: regions: `region` unique, `class` in
  [`region_classes()`](https://ljwharbers.github.io/scphasedcn/reference/region_classes.md)

- `check_votes()`: molecule votes: `cell` (index into the cells),
  `atom`, `ps`, `nA`, `nB`

- `check_atoms()`: allele atoms: `atom`, `chrom`, `start`, `end`, `bin`

- `check_features()`: features long table (one row per cell x region)

- `check_thresholds()`: null thresholds per score x class x stratum x
  fold

- `check_calls()`: calls: `level` cell\|pool\|clone, `source`
  cell\|inherited\|confirmed

- `check_segments()`: clone segments
