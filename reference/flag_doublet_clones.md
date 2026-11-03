# Flag clones that are 50:50 mixtures of two other clones

For each clone m and each pair (k, l) of larger clones, the profile of m
is scored under the mixture of k's and l's segment states (copy number
averaged; major fraction mixed with the better of same / opposite
haplotype per window, attenuated by m's `a`) with m's depth contrast,
and under m's own segments. A clone whose mixture log-likelihood is
within `delta` of its own is a doublet clone.

## Usage

``` r
flag_doublet_clones(
  clones,
  segments,
  profiles,
  fit = NULL,
  delta = 10,
  df = 5,
  pairs = NULL
)
```

## Arguments

- clones:

  data.table clone, n_cells (or cell, clone)

- segments:

  segments table

- profiles:

  clone profiles
  ([`clone_profiles()`](https://ljwharbers.github.io/scphasedcn/reference/clone_profiles.md))

- fit:

  optional
  [`fit_clone_states()`](https://ljwharbers.github.io/scphasedcn/reference/fit_clone_states.md)
  result (for c, a, rho and the effective SE)

- delta:

  log-likelihood tolerance

- df:

  depth t degrees of freedom

- pairs:

  optional 2-column matrix of the clone pairs that may form a doublet
  clone (default all pairs);
  [`caller_tumour()`](https://ljwharbers.github.io/scphasedcn/reference/caller_tumour.md)
  passes the pairs of different trunks: a clone between two sibling
  clones of one trunk is a subclone with intermediate states, not a
  doublet population

## Value

data.table clone, best_pair, ll_self, ll_mix, delta_ll, doublet
