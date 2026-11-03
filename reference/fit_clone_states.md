# Fit clone copy-number states

Per clone, a grid search over the depth contrast `c` (state mean
`c * log2(cn / base)`, `base` = the profile's copy-number baseline: the
reference ploidy for pool-relative profiles, else 2; haploid windows
(male chrX / chrY, `ploidy` 1) allow only nB = 0 states and their labels
are relative to one copy; `c` \>= 0.6 because absolute ploidy is
unidentifiable: states are relative to the clone baseline), the
orientation attenuation `a` (expected major fraction
`0.5 + a * (f_state - 0.5)`) and the window-level overdispersion `rho`.
Emissions: Student-t (`df`) on the window log2 with scale = the window
SE combined with the clone's systematic window noise and inflated for
its autocorrelation (see `clone_noise`), and a two-sided robust
beta-binomial on (nA, n_hap) (a 5 % component with 10x the
overdispersion). The objective is the per-window mixture likelihood over
the states with the grid `prior` weights.

## Usage

``` r
fit_clone_states(
  profile,
  grid = cn_grid(),
  contrast = seq(0.6, 1, 0.05),
  atten = seq(0.6, 1, 0.05),
  rho = c(0.001, 0.003, 0.01, 0.03),
  df = 5,
  eps = 0.02,
  refine = TRUE,
  p_switch = 0.001,
  min_win = 3
)
```

## Arguments

- profile:

  output of
  [`clone_profiles()`](https://ljwharbers.github.io/scphasedcn/reference/clone_profiles.md)

- grid:

  state grid
  ([`cn_grid()`](https://ljwharbers.github.io/scphasedcn/reference/cn_grid.md))

- contrast:

  grid of depth contrasts

- atten:

  grid of orientation attenuations

- rho:

  grid of window-level overdispersions

- df:

  degrees of freedom of the depth t

- eps:

  allele error floor

- refine:

  refine (c, a, rho) on the segment level: segment at the current fit
  (Viterbi, `p_switch`, `min_win`), then maximise the sum over segments
  of the best state's segment likelihood (depth on the
  precision-weighted segment mean, alleles summed over its windows); two
  passes

- p_switch, min_win:

  segmentation parameters of the refinement (as
  [`segment_clone()`](https://ljwharbers.github.io/scphasedcn/reference/segment_clone.md))

## Value

list(ll = data.table clone, window, chrom, start, end, ploidy, state,
label, ll (emission log-likelihood at the chosen parameters), windows =
the profile with `se_eff`, par = data.table clone, c, a, rho, s_sys,
loglik, grid)
