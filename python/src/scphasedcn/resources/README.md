Bundled hg38 reference tables (defaults of `scphasedcn extract` / `run`; override with `--chrom-sizes`, `--blacklist`,
`--centromeres` or the sample yaml's `reference:` block).

- `hg38.chrom.sizes`: chromosome sizes of GRCh38 with `chr` names (194 contigs; `cut -f1,2 genome.fa.fai` of the 10x
  Genomics GRCh38-2020-A FASTA, whose primary chromosomes are the GRCh38 / hg38 primary assembly).
- `hg38-blacklist.v2.bed`: ENCODE Blacklist v2 for hg38 (636 regions), from https://github.com/Boyle-Lab/Blacklist
  (`lists/hg38-blacklist.v2.bed.gz`). Cite: Amemiya HM, Kundaje A, Boyle AP. The ENCODE Blacklist: identification of
  problematic regions of the genome. Sci Rep 9, 9354 (2019). https://doi.org/10.1038/s41598-019-45839-z
- `centromeres_hg38.tsv`: centromere coordinates (columns chr, start, cen.left.base, cen.right.base, end; 1-based;
  chrX as `chr23`), the `chromosome_coordinates_hg38_chr.txt` table of Battenberg
  (https://github.com/Wedge-lab/battenberg). The same table ships with the scphasedcn R package (`inst/extdata/centromeres_hg38.tsv`).

Not bundled (pass a path): the reference FASTA (`--fasta`, required: GC per bin) and a tandem-repeat BED (`--trf`,
optional; e.g. the TRF annotation of the GRCh38 no-alt analysis set).
