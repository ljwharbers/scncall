# Phasing regime of a votes table

`"chromosome"` (one phase set per chromosome, e.g. a hybrid longphase +
population phase) when the median over chromosomes of the number of
phase sets needed to hold `frac` of the chromosome's votes is at most 2,
else `"block"` (unoriented blocks). Vote-weighted so that the residual
small phase sets of a hybrid phase (many small phase sets next to one
that holds nearly all votes) do not count; without residual sets this is
the "median number of distinct phase sets \<= 2" rule.

## Usage

``` r
detect_phasing(votes, atoms, frac = 0.9)
```

## Arguments

- votes:

  votes table

- atoms:

  atoms table

- frac:

  vote fraction the counted phase sets must hold

## Value

"chromosome" or "block"
