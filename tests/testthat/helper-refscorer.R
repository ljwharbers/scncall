# helper-refscorer.R
# What: a FROZEN reference implementation of the scorer used to check the package functions: allelic LLRs,
#       the attenuation grid, the Student-t null fit, per-state scores, null quantiles, concordance,
#       cross-validated and all-null calls, pooled scores and the constants they use (all with a `ref_` /
#       `REF_` prefix).
# Why: parity oracle for the caller (R/caller_core.R, R/caller.R): the package functions must reproduce these
#      numbers exactly. Do NOT edit or "improve" this file; the package code is checked against the
#      definitions frozen here.
# Inputs: cell x region data.tables (z, sd_null, haplotype votes, class, stratum, fold). Outputs: data.tables /
#         vectors.

REF_NULL_Q = 0.999                      # budget: 1 false call per 1,000 null cell-regions
REF_EPS = 0.02                          # allele error floor of the beta-binomial

# ---- allelic channel: oriented two-sided beta-binomial LLRs ------------------------------------------
#' Oriented allelic LLRs from haplotype counts
#' @param nA,n molecule votes for haplotype A and total
#' @param rho oriented beta-binomial overdispersion (null fit)
#' @return data.table f, llr_20, llr_21, llr_31, llr_best
ref_allelic_llr = function(nA, n, rho, eps = REF_EPS) {
  two_sided = function(f) pmax(bb_loglik(nA, n, f, rho, eps), bb_loglik(nA, n, 1 - f, rho, eps)) - bb_loglik(nA, n, 0.5, rho, eps)
  d = data.table(f = ifelse(n > 0, nA / n, NA_real_), llr_20 = two_sided(1 - eps), llr_21 = two_sided(2 / 3), llr_31 = two_sided(3 / 4))
  d[n == 0, c("llr_20", "llr_21", "llr_31") := 0]
  d[, llr_best := pmax(llr_20, llr_21, llr_31)]
  d[]
}

#' Best two-sided oriented LLR over a grid of haplotype fractions (attenuation-aware 1:0 / 2:0 term)
#' @param fs candidate major-haplotype fractions, e.g. c(0.85, 0.9, 0.95, 0.98) for an attenuated 1:0 / 2:0
ref_llr_grid = function(nA, n, rho, fs, eps = REF_EPS) {
  ll0 = bb_loglik(nA, n, 0.5, rho, eps)
  best = rep(-Inf, length(n))
  for (f in fs) best = pmax(best, pmax(bb_loglik(nA, n, f, rho, eps), bb_loglik(nA, n, 1 - f, rho, eps)) - ll0)
  best[n == 0] = 0
  best
}
REF_F_ATT = c(0.85, 0.90, 0.95, 0.98)   # 1:0 / 2:0 haplotype fractions after attenuation by phasing errors

# ---- depth null model ------------------------------------------------------------------------------------
#' Location-scale Student-t fit of null depth z per group (MASS::fitdistr on a subsample)
#' @param d null rows with z and the grouping columns
#' @param by grouping columns (region class x depth stratum)
#' @return data.table by-columns, t_m, t_s, t_df, n
ref_fit_t = function(d, by = c("class", "stratum"), n_max = 20000, seed = 1) {
  d[is.finite(z), {
    set.seed(seed)
    x = if (.N > n_max) z[sample.int(.N, n_max)] else z
    f = tryCatch(suppressWarnings(MASS::fitdistr(x, "t")$estimate), error = function(e) c(m = median(x), s = mad(x), df = 30))
    list(t_m = f[["m"]], t_s = f[["s"]], t_df = f[["df"]], n = .N)
  }, by = by]
}

# ---- per-state log-likelihoods and scores --------------------------------------------------------------
#' Per-state LLRs (vs neutral) of depth, alleles and their sum
#'
#' Depth: a location-shift model on the window z (z = log2ratio / max(sd_null, 0.05)). A state with log2 shift
#' delta_s moves the cell's z by mu_s = delta_s / max(sd_null, 0.05) (the cell's own null SD); the depth LLR is
#' log f0(z - mu_s) - log f0(z) with f0 the null density of z: `model = "gauss"` f0 = N(0, 1) (the specified
#' Gaussian), `model = "t"` f0 = the Student-t fitted to the null z of the row's class x stratum (`tpar`, from
#' ref_fit_t; the null z is heavy-tailed). Shifts in log2 units (loss < 0, gain > 0, CN-LOH 0).
#' Alleles: loss and CN-LOH use llr_20 (2:0 / 1:0, f ~ 1), gain the better of llr_21 / llr_31.
#' States: neutral, loss (depth down + 1:0), gain (depth up + 2:1 / 3:1), cnloh (depth neutral + 2:0).
#' Missing channel values contribute 0 (no evidence).
#' @param d data.table with z, sd_null, llr_20, llr_21, llr_31 (+ class, stratum for model "t")
#' @param shift named log2 shifts c(loss = , gain = )
#' @param model "t" or "gauss"; @param tpar output of ref_fit_t (model "t")
#' @return d with dl_loss, dl_gain (depth), al_loss, al_gain, al_cnloh (alleles), cl_* (combined), and the scores
#'   s_depth (|z|), s_allelic (llr_best), s_comb (best combined state LLR), state_comb, state_depth,
#'   state_allelic
ref_score = function(d, shift, model = "t", tpar = NULL) {
  d = copy(d)
  for (cn in c("z", "llr_20", "llr_21", "llr_31")) if (!cn %in% names(d)) d[, (cn) := NA_real_]
  d[, sdp := pmax(fifelse(is.na(sd_null), 1, sd_null), 0.05)]
  zz = fifelse(is.na(d$z), 0, d$z)
  mu_l = shift[["loss"]] / d$sdp; mu_g = shift[["gain"]] / d$sdp
  if (model == "gauss") {
    d[, dl_loss := fifelse(is.na(z), 0, mu_l * zz - mu_l^2 / 2)]
    d[, dl_gain := fifelse(is.na(z), 0, mu_g * zz - mu_g^2 / 2)]
  } else {
    k = match(paste(d$class, d$stratum), paste(tpar$class, tpar$stratum))
    if (anyNA(k)) stop("no t fit for some class x stratum")
    m = tpar$t_m[k]; s = tpar$t_s[k]; df = tpar$t_df[k]
    lt = function(x) dt((x - m) / s, df, log = TRUE)
    d[, dl_loss := fifelse(is.na(z), 0, lt(zz - mu_l) - lt(zz))]
    d[, dl_gain := fifelse(is.na(z), 0, lt(zz - mu_g) - lt(zz))]
  }
  a20 = fifelse(is.na(d$llr_20), 0, d$llr_20); ag = pmax(fifelse(is.na(d$llr_21), 0, d$llr_21), fifelse(is.na(d$llr_31), 0, d$llr_31))
  d[, `:=`(al_loss = a20, al_cnloh = a20, al_gain = ag)]
  d[, `:=`(cl_loss = dl_loss + al_loss, cl_gain = dl_gain + al_gain, cl_cnloh = al_cnloh)]
  M = as.matrix(d[, .(cl_loss, cl_gain, cl_cnloh)])
  d[, s_comb := do.call(pmax, as.data.frame(M))]
  d[, state_comb := c("loss", "gain", "cnloh")[max.col(M, ties.method = "first")]]
  d[, s_depth := abs(zz)]
  d[, state_depth := fifelse(zz < 0, "loss", "gain")]
  d[, s_allelic := pmax(a20, ag)]
  d[, state_allelic := fifelse(a20 >= ag, "loss_or_cnloh", "gain")]
  d[, sdp := NULL]
  d[]
}

#' Empirical upper-tail threshold of a score (the null_q quantile)
ref_q = function(x, q = REF_NULL_Q) { x = x[is.finite(x)]; if (length(x) == 0) NA_real_ else unname(quantile(x, q, type = 7)) }

#' Concordance-rule scores: percentile of each channel's evidence for a direction in a reference null, both required
#' S_loss = min(F(-z), F(llr_20)); S_gain = min(F(z), F(max(llr_21, llr_31))); S = max(S_loss, S_gain).
#' Calling S >= t means both channels pass their (t) null quantile in the same direction. CN-LOH has no depth
#' evidence and cannot be called by this rule.
#' @param d rows to score (z, llr_*), @param ref null rows that define the percentiles
ref_concordance = function(d, ref) {
  ecdf_at = function(ref_x, x) { r = sort(ref_x[is.finite(ref_x)]); findInterval(x, r) / length(r) }
  zr = fifelse(is.na(ref$z), 0, ref$z); zd = fifelse(is.na(d$z), 0, d$z)
  a20r = fifelse(is.na(ref$llr_20), 0, ref$llr_20); a20d = fifelse(is.na(d$llr_20), 0, d$llr_20)
  agr = pmax(fifelse(is.na(ref$llr_21), 0, ref$llr_21), fifelse(is.na(ref$llr_31), 0, ref$llr_31))
  agd = pmax(fifelse(is.na(d$llr_21), 0, d$llr_21), fifelse(is.na(d$llr_31), 0, d$llr_31))
  s_loss = pmin(ecdf_at(-zr, -zd), ecdf_at(a20r, a20d))
  s_gain = pmin(ecdf_at(zr, zd), ecdf_at(agr, agd))
  data.table(s_conc = pmax(s_loss, s_gain), state_conc = fifelse(s_loss >= s_gain, "loss", "gain"))
}

#' Fold-cross-validated calls on a scored table
#'
#' Thresholds per (class, stratum) from null rows of the training folds (all folds except the row's own), applied to
#' every row of the held-out fold (null rows -> realised false-call rate; spiked copies -> recall).
#' @param d scored table with columns class, stratum, fold, is_null (logical), the score columns
#' @param scores score columns
#' @param conc also compute the concordance variant (needs z, llr_*)
#' @return d with thr_<score>, call_<score> (logical) per score (+ s_conc, thr_conc, call_conc)
ref_cv_calls = function(d, scores = c("s_depth", "s_allelic", "s_comb"), conc = TRUE, q = REF_NULL_Q) {
  out = list()
  for (cl in unique(d$class)) for (st in unique(d$stratum)) for (fo in sort(unique(d$fold))) {
    test = d[class == cl & stratum == st & fold == fo]
    if (nrow(test) == 0) next
    train = d[class == cl & stratum == st & fold != fo & is_null == TRUE]
    # strict ">": allelic LLRs are discrete at small molecule counts, ">=" would call every row on the atom
    for (s in scores) {
      thr = ref_q(train[[s]], q)
      test[, (paste0("thr_", s)) := thr]
      test[, (paste0("call_", s)) := get(s) > thr]
    }
    if (conc) {
      cc = ref_concordance(test, train); ct = ref_concordance(train, train)
      thr = ref_q(ct$s_conc, q)
      test[, `:=`(s_conc = cc$s_conc, state_conc = cc$state_conc, thr_conc = thr, call_conc = cc$s_conc > thr)]
    }
    test[, n_train_null := nrow(train)]
    out[[length(out) + 1]] = test
  }
  rbindlist(out, fill = TRUE)
}

#' Non-CV calls: thresholds per (class, stratum) from all null rows
ref_calls = function(d, scores = c("s_depth", "s_allelic", "s_comb"), conc = TRUE, q = REF_NULL_Q) {
  d = copy(d)
  d[, fold := 0L]
  nul = copy(d[is_null == TRUE]); nul[, fold := -1L]
  r = ref_cv_calls(rbind(d, nul), scores, conc, q)
  r[fold == 0L]
}

# ---- pooled scores ---------------------------------------------------------------------------------------
#' Pooled (summed over cells) state LLRs and score of a set of rows grouped by `pool`
#' depth and combined: max over states of the summed per-cell state LLRs; alleles: same with the allelic terms;
#' the gain state keeps llr_21 and llr_31 separate before summing.
ref_pool_scores = function(d) {
  d = copy(d)
  for (cn in c("llr_21", "llr_31")) d[is.na(get(cn)), (cn) := 0]
  p = d[, .(dl_loss = sum(dl_loss), dl_gain = sum(dl_gain), a20 = sum(al_loss), a21 = sum(llr_21), a31 = sum(llr_31), n = .N), by = pool]
  p[, s_depth := pmax(dl_loss, dl_gain)][, state_depth := fifelse(dl_loss >= dl_gain, "loss", "gain")]
  p[, s_allelic := pmax(a20, a21, a31)][, state_allelic := fifelse(a20 >= pmax(a21, a31), "loss_or_cnloh", "gain")]
  M = cbind(p$dl_loss + p$a20, p$dl_gain + pmax(p$a21, p$a31), p$a20)
  p[, s_comb := do.call(pmax, as.data.frame(M))][, state_comb := c("loss", "gain", "cnloh")[max.col(M, ties.method = "first")]]
  p[]
}
