# Allele-specific copy-number state grid

nA:nB states relative to a diploid clone baseline: neutral 1:1, loss
1:0, cnloh 2:0, gain 2:1, gain_as 3:0 (allele-specific gain), amp 3:1 /
2:2 / 4:1 / 4:0, del 0:0. `f` is the major-haplotype fraction, `prior` a
log weight used by
[`fit_clone_states()`](https://ljwharbers.github.io/scphasedcn/reference/fit_clone_states.md)
(mixture over states) and by the Viterbi transitions of
[`segment_clone()`](https://ljwharbers.github.io/scphasedcn/reference/segment_clone.md).

## Usage

``` r
cn_grid(max_cn = 5)
```

## Arguments

- max_cn:

  maximal total copy number

## Value

data.table state, nA, nB, cn, f, label, prior
