#!/usr/bin/env bash
# smoke_test.sh: end-to-end check of an installation (conda env, container or source install): the extractor's CLI
# answers, a simulated extraction directory goes through the caller's command line, and the outputs exist.
# Usage: tools/smoke_test.sh [workdir]
#   container: apptainer exec scphasedcn.sif bash tools/smoke_test.sh
set -euo pipefail
W=${1:-$(mktemp -d)}
mkdir -p "$W"
scphasedcn --version
scphasedcn run --help > /dev/null
CALL=$(command -v call_scn.R || Rscript -e 'cat(system.file("scripts", "call_scn.R", package = "scphasedcn"))')
Rscript - "$W" <<'EOF'
suppressPackageStartupMessages({ library(scphasedcn); library(data.table) })
w = commandArgs(trailingOnly = TRUE)[1]
ev = data.table(chrom = "chr1", start = 0, end = 24e6, cnA = 1L, cnB = 0L, type = "private")
s = simulate_scn(n_cells = 80, sex = "female", cell_types = c(a = 0.5, b = 0.5), events = ev, private_frac = 0.1,
                 multiplet_rate = 0, depth = c(meanlog = log(12000), sdlog = 0.3), phase_block_mean = 1e9,
                 switch_rate = 2e-6, seed = 1)
invisible(write_sim_dataset(s, file.path(w, "extract")))
cen = s$scn$bins[, .(cstart = 1, len = max(end)), by = chrom]
fwrite(cen[, .(chrom, cstart, cen_left = 0.4 * len, cen_right = 0.4 * len, cend = len)], file.path(w, "cen.tsv"), sep = "\t")
EOF
Rscript "$CALL" --dir "$W/extract" --out "$W/caller" --sex female --centromeres "$W/cen.tsv" --null-cells select --cores 2
for f in cells.tsv calls.tsv events.tsv thresholds.tsv params.yaml NOTES.md result.rds; do
  test -s "$W/caller/$f" || { echo "missing output: $f" >&2; exit 1; }
done
echo "smoke test passed: $W/caller"
