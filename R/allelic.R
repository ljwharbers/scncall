# allelic.R
# What: beta-binomial primitives of the read-phased allelic channel: the
#       allelic states {1:1, 1:0, 2:1, 3:1, 4:1, 2:0}, the beta-binomial
#       log-likelihood, the overdispersion MLE on balanced counts, and the
#       expected attenuation of the anchored imbalance by switch errors.
# Why: allelic imbalance is depth-independent and the only channel that sees
#      copy-neutral LOH; the caller (features.R, caller_core.R, clones_*.R) and
#      the MEDICC2 per-cell states build on these.
# Inputs: counts / totals / means. Outputs: numeric vectors and data.tables.

#' Allelic states
#' @return data.table state, nA, nB, f (hap-A fraction; A is the major haplotype)
#' @export
imbalance_states = function() {
  data.table(state = c("1:1", "1:0", "2:1", "3:1", "4:1", "2:0"),
             nA = c(1, 1, 2, 3, 4, 2), nB = c(1, 0, 1, 1, 1, 0),
             f = c(0.5, 1, 2 / 3, 0.75, 0.8, 1))
}

#' Beta-binomial log-likelihood
#' @param a successes (hap-A counts)
#' @param n trials
#' @param f mean
#' @param rho overdispersion between 0 and 1; 0 = binomial
#' @param eps floor/ceiling applied to f (allele error)
#' @return log-likelihood vector
#' @export
bb_loglik = function(a, n, f, rho = 0.02, eps = 0.02) {
  f = pmin(pmax(f, eps), 1 - eps)
  if (rho <= 0) return(dbinom(a, n, f, log = TRUE))
  al = f * (1 - rho) / rho; be = (1 - f) * (1 - rho) / rho
  lchoose(n, a) + lbeta(a + al, n - a + be) - lbeta(al, be)
}

#' Fit the beta-binomial overdispersion on balanced (flat) counts
#' @param a hap-A counts
#' @param n totals
#' @param f mean (0.5 for flat cells)
#' @return rho (MLE between 1e-4 and 0.5)
#' @export
fit_bb_rho = function(a, n, f = 0.5) {
  ok = n > 0
  optimize(function(r) -sum(bb_loglik(a[ok], n[ok], f, r)), c(1e-4, 0.5))$minimum
}

#' Expected attenuation of the anchored imbalance by switch errors
#'
#' Within a block of k SNPs with per-SNP switch probability p the fraction
#' of SNPs in the flipped parity state is q = (1/k) sum_j (1 - (1 - 2p)^j) / 2,
#' and the anchored deviation |f - 0.5| is multiplied by (1 - 2q).
#' @param switch_rate per-SNP switch probability
#' @param n_snps SNPs per block (vector allowed; the mean factor is returned)
#' @return attenuation factor in (0, 1]
#' @export
switch_attenuation = function(switch_rate, n_snps) {
  fac = sapply(n_snps, function(k) {
    if (k < 1) return(1)
    q = mean((1 - (1 - 2 * switch_rate)^(seq_len(k))) / 2)
    1 - 2 * q
  })
  mean(fac)
}
