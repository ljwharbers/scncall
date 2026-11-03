# test-bins.R: bin construction, lookup, windows, arm annotation.
test_that("make_bins and locate_bins agree", {
  b = make_bins(c(chr1 = 1e6, chr2 = 250001), 1e5)
  expect_equal(nrow(b), 10 + 3)
  expect_equal(b$end[13], 250001)
  idx = locate_bins(b, c("chr1", "chr2", "chr2", "chr3"), c(0, 99999, 250000, 5))
  expect_equal(idx, c(1L, 11L, 13L, NA))
})

test_that("window ids and window tables cover the bins", {
  scn = sim_flat$scn
  ids = window_ids(scn$bins, 1e6)
  wt = window_table(scn$bins, ids)
  expect_equal(sum(wt$n_bins), nrow(scn$bins))
  expect_true(all(wt$n_bins <= 10))
  expect_equal(unique(window_ids(scn$bins, "chrom")), unique(scn$bins$chrom))
})

test_that("arms are annotated", {
  b = make_bins(c(chr1 = 1e6), 1e5)
  cen = data.table::data.table(chr = "chr1", start = 1, cen.left.base = 400000, cen.right.base = 600000, end = 1e6)
  a = annotate_arms(b, cen, pad = 0)
  expect_equal(a$arm, c(rep("p", 4), "cen", "cen", rep("q", 4)))
  expect_true(all(a$is_centromere[5:6]))
  expect_identical(names(cen)[1], "chr")              # the input table is not modified
  # Battenberg names chrX chr23: chrX bins get arms and centromere flags
  bx = make_bins(c(chrX = 1e6), 1e5)
  ax = annotate_arms(bx, data.table::data.table(chr = "chr23", start = 1, cen.left.base = 400000,
                                                cen.right.base = 600000, end = 1e6), pad = 0)
  expect_equal(ax$arm, a$arm)
  expect_true(all(ax$is_centromere[5:6]))
  # the bundled hg38 table flags the chrX centromere
  ah = annotate_arms(make_bins(c(chrX = 156040895), 1e6))
  expect_true(any(ah$is_centromere) && !anyNA(ah$arm))
})
