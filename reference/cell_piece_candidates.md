# Candidate per-cell states of the MEDICC2 pieces

Per piece, the distinct oriented `(cn_a, cn_b)` of the clones plus the
neutral state (1:1 on diploid pieces, 1:0 on haploid pieces such as male
chrX; haploid pieces keep only `cn_b = 0` states). The prior is uniform
over a piece's candidates (`uniform`), `p_neutral` on the neutral state
and the rest split evenly (`neutral`), or (`clone_freq`) proportional to
the summed size (`n_assigned`, else 1 per clone) of the clones carrying
the state plus a pseudo-count of `pseudo` x the total size (so that a
state no clone has, e.g. the neutral state of an all-gained piece, keeps
a small prior).

## Usage

``` r
cell_piece_candidates(
  pieces,
  clones = NULL,
  prior = c("uniform", "clone_freq", "neutral"),
  pseudo = 0.01,
  p_neutral = 0.5
)
```

## Arguments

- pieces:

  long table clone x piece with
  `piece, chrom, start, end, clone, cn_a, cn_b` (+ `ploidy`, default 2)

- clones:

  optional clones table (`clone`, `n_assigned`) for the `clone_freq`
  prior

- prior:

  `uniform`, `clone_freq` or `neutral` (`p_neutral` on the neutral
  state, the rest split evenly over the other candidates: the clone
  model's state prior,
  [`cn_grid()`](https://ljwharbers.github.io/scphasedcn/reference/cn_grid.md),
  also gives the neutral state 0.5)

- pseudo:

  pseudo-count (fraction of the total clone size) of the `clone_freq`
  prior

- p_neutral:

  neutral prior mass of `prior = "neutral"`

## Value

data.table piece, chrom, start, end, ploidy, cn_a, cn_b, cn, state
(`cn_a:cn_b`), neutral, n_clones (clones with the state), w_clones
(their summed size), prior (sums to 1 per piece)
