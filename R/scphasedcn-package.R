# scphasedcn-package.R
# What: package-level documentation and imports.
# Why: roxygen2 generates NAMESPACE from these tags; keeping all cross-package
#      imports here avoids scattered @importFrom lines and makes R CMD check
#      report unused imports in one place.
# Inputs: none. Outputs: none (documentation only).

#' scphasedcn: single-cell copy-number calling from long-read single-cell DNA data
#'
#' The caller [call_scn()] runs on an extraction directory written by the
#' companion Python extractor (`scphasedcn run`): per-cell region features
#' ([cell_features()]), then a normal-tissue mode ([caller_normal()]) or a
#' tumour mode ([caller_tumour()]: clone discovery, clone states, cell
#' re-assignment); [write_scphasedcn()] writes the result tables. Supporting
#' functions: readers for the extraction outputs ([read_bins_h5ad()],
#' [read_fragments()]), bins and arms ([annotate_arms()], [bin_filter()]),
#' the depth references behind [normalise_depth()], beta-binomial allelic
#' primitives, the MEDICC2 export ([medicc2_pieces()], [medicc2_table()]), plot helpers and a
#' generative simulator ([simulate_scn()], [write_sim_dataset()]) used by the
#' examples and tests. Start with `vignette("scphasedcn")`.
#'
#' Conventions: matrices are bins x cells (`dgCMatrix` for counts, dense for
#' ratios); coordinates are 0-based half-open as in BED / the Python
#' extraction layer; `=` assignment and data.table throughout.
#'
#' @keywords internal
#' @aliases scphasedcn-package
#' @import data.table
#' @importFrom methods as is new
#' @importFrom stats median quantile rnorm rpois runif rbinom rgamma rlnorm rexp
#'   sd var cor lm loess predict dnbinom dpois dbinom pnorm qpois ppois
#'   lowess optimize uniroot setNames weighted.mean mad complete.cases
#'   dbeta pbinom dnorm ave approx dt qnorm
#' @importFrom splines ns
#' @importFrom utils head tail
#' @importFrom Matrix sparseMatrix colSums rowSums t crossprod Diagonal
"_PACKAGE"

# data.table NSE variables used across the package (silences R CMD check notes)
utils::globalVariables(c(
  ".", "S", "bin", "bin_id", "chrom", "cell", "nucleus", "hap", "len", "strand", "mapq", "flags", "n_snps", "i", "j", "mid",
  "pos", "ps", "hap_of_alt", "hap_true", "alt_obs", "region", "n", "arm", "is_centromere", "frac_blacklist",
  "frac_trf", "peak_bp", "cell_type", "n_frag", "state", "llr", "idx", "excess", "type", "cn", "N", "id", "block",
  "a", "nA", "nB", "prob", "score", "x", "label", "multiplet", "k", "n_cells", "orient", "tmp", "level", "flat",
  "pool", "called", "half", "ll", "flip", "snp", "alt", "n_peaks", "n_nuclei", "members", "depth_true",
  "hap_of_alt_true", "path", "n_bins", "width", "piece", "eligible", "imbalanced", "f_mirror",
  "log2ratio", "ll_depth", "group", "event", "name", "qc_pass", "chrx", "sep", "i.s_comb", "s_sys", "null",
  "allelic"
))
