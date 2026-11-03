# bins.R
# What: bin construction (simulator), chromosome sizes from a FASTA index,
#       arms from the Battenberg centromere table, the usable-bin filter, and
#       window ids / tables for aggregation to coarser grids.
# Why: every channel is measured on the same bin grid; the Python extraction
#      annotates GC / blacklist / TRF / peaks per bin, the R side adds arms and
#      decides which bins enter the normalisation.
# Inputs: chromosome sizes or an existing bins table; the centromere table
#         (hg38_centromeres() or a Battenberg-format file). Outputs: data.tables.

#' Tile chromosomes into fixed-width bins
#' @param chrom_sizes named numeric vector (bp)
#' @param bin_size bin width (bp); the last bin of a chromosome is truncated
#' @return data.table bin_id, chrom, start, end (0-based half-open)
#' @export
make_bins = function(chrom_sizes, bin_size = 1e5) {
  out = rbindlist(lapply(names(chrom_sizes), function(ch) {
    s = seq(0, chrom_sizes[[ch]] - 1, by = bin_size)
    data.table(chrom = ch, start = s, end = pmin(s + bin_size, chrom_sizes[[ch]]))
  }))
  out[, bin_id := seq_len(.N)]
  setcolorder(out, c("bin_id", "chrom", "start", "end"))
  out[]
}

#' Chromosome sizes from a FASTA index (.fai)
#' @param fai path to `genome.fa.fai` (or the FASTA; `.fai` is appended)
#' @param chroms chromosomes to keep (default chr1-22, X, Y)
#' @return named numeric vector
#' @export
read_chrom_sizes = function(fai, chroms = paste0("chr", c(1:22, "X", "Y"))) {
  if (!grepl("\\.fai$", fai)) fai = paste0(fai, ".fai")
  d = fread(fai, header = FALSE, select = 1:2, col.names = c("chrom", "len"))
  d = d[chrom %in% chroms]
  d = d[order(chrom_rank(chrom))]
  setNames(as.numeric(d$len), d$chrom)
}

#' Chromosome arms and centromere flags from the Battenberg coordinate table
#' @param bins bins table
#' @param centromeres path to `chromosome_coordinates_hg38_chr.txt` (columns
#'   chr, start, cen.left.base, cen.right.base, end) or a data.table; chrX / chrY may be named `chr23` / `chr24`
#'   (as in the Battenberg table)
#' @param pad bp around the centromere flagged as centromeric
#' @return bins with columns arm ("p"/"q"), is_centromere
#' @export
annotate_arms = function(bins, centromeres = hg38_centromeres(), pad = 1e6) {
  bins = copy(bins)
  ce = if (is.character(centromeres)) fread(centromeres) else copy(as.data.table(centromeres))
  setnames(ce, 1:5, c("chrom", "cstart", "cen_left", "cen_right", "cend"))
  ce[, chrom := as.character(chrom)]
  ce[chrom %in% c("chr23", "23"), chrom := "chrX"]   # Battenberg names chrX / chrY chr23 / chr24
  ce[chrom %in% c("chr24", "24"), chrom := "chrY"]
  bins[, arm := NA_character_]
  bins[, is_centromere := FALSE]
  for (r in seq_len(nrow(ce))) {
    ch = ce$chrom[r]
    bins[chrom == ch, arm := ifelse(end <= ce$cen_left[r], "p", ifelse(start >= ce$cen_right[r], "q", "cen"))]
    bins[chrom == ch & end > ce$cen_left[r] - pad & start < ce$cen_right[r] + pad, is_centromere := TRUE]
  }
  bins[]
}

#' Path of the hg38 centromere table shipped with the package
#'
#' The Battenberg `chromosome_coordinates_hg38_chr.txt` coordinates (columns chr, start, cen.left.base,
#' cen.right.base, end; chrX as `chr23`), copied into `inst/extdata/centromeres_hg38.tsv`. It is the default
#' `centromeres` of [cell_features()], [call_scn()] and [annotate_arms()].
#' @return file path
#' @export
#' @examples
#' head(data.table::fread(hg38_centromeres()))
hg38_centromeres = function() {
  f = system.file("extdata", "centromeres_hg38.tsv", package = "scphasedcn")
  if (!nzchar(f)) stop("hg38_centromeres: centromeres_hg38.tsv is missing from the installed package")
  f
}

#' Usable-bin flag
#'
#' Drops centromeric bins, bins with high blacklist / TRF fraction, extreme or
#' missing GC and (optionally) bins with too low pseudobulk coverage.
#' @param bins bins table
#' @param counts optional bins x cells matrix for the coverage filter
#' @param max_blacklist,max_trf fraction thresholds
#' @param gc_range allowed GC range
#' @param min_cov_frac pseudobulk coverage must exceed this fraction of the median
#' @param chroms chromosomes to keep (NULL = all)
#' @return logical vector `use`
#' @export
bin_filter = function(bins, counts = NULL, max_blacklist = 0.1, max_trf = 0.2, gc_range = c(0.3, 0.65),
                      min_cov_frac = 0.1, chroms = NULL) {
  use = rep(TRUE, nrow(bins))
  if ("is_centromere" %in% names(bins)) use = use & !bins$is_centromere
  if ("frac_blacklist" %in% names(bins)) use = use & bins$frac_blacklist <= max_blacklist
  if ("frac_trf" %in% names(bins)) use = use & bins$frac_trf <= max_trf
  if ("gc" %in% names(bins)) use = use & !is.na(bins$gc) & bins$gc >= gc_range[1] & bins$gc <= gc_range[2]
  if (!is.null(chroms)) use = use & bins$chrom %in% chroms
  if (!is.null(counts)) {
    pb = rowSums(counts)
    use = use & pb >= min_cov_frac * median(pb[use & pb > 0])
  }
  use
}

#' Window id per bin for aggregation to a coarser grid
#' @param bins bins table
#' @param size window size in bp; or "arm" for chromosome arms; or "chrom"
#' @return character window id per bin (NA for bins without an arm when size = "arm")
#' @export
window_ids = function(bins, size = 1e6) {
  if (identical(size, "chrom")) return(bins$chrom)
  if (identical(size, "arm")) {
    if (!"arm" %in% names(bins)) stop("bins need an `arm` column (annotate_arms)")
    id = paste0(bins$chrom, bins$arm)
    id[is.na(bins$arm) | bins$arm == "cen"] = NA
    return(id)
  }
  paste0(bins$chrom, ":", formatC(floor(bins$start / size) * size, format = "d", big.mark = ""))
}

#' Windows table (coordinates per window id)
#' @param bins bins table
#' @param ids window ids from [window_ids()]
#' @return data.table window, chrom, start, end, n_bins
#' @export
window_table = function(bins, ids) {
  d = data.table(window = ids, chrom = bins$chrom, start = bins$start, end = bins$end)[!is.na(window)]
  d[, .(chrom = chrom[1], start = min(start), end = max(end), n_bins = .N), by = window]
}
