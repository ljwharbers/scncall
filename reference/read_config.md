# Read a YAML config (sample yaml or caller yaml)

Uses the yaml package when installed, otherwise a minimal parser for the
subset used in the sample and caller yaml files (nested maps, scalars,
inline `[a, b]` lists and `{k: v}` maps, `#` comments). The sample yaml
layout is
`system.file("extdata", "sample_template.yaml", package = "scphasedcn")`.

## Usage

``` r
read_config(file)
```

## Arguments

- file:

  path

## Value

nested list

## Examples

``` r
str(read_config(system.file("extdata", "sample_template.yaml", package = "scphasedcn"))$samples)
#> List of 1
#>  $ my_sample:List of 6
#>   ..$ type      : chr "normal"
#>   ..$ sex       : chr "female"
#>   ..$ bam       : chr "/path/to/my_sample.dna.bam"
#>   ..$ barcodes  : chr "/path/to/cell_barcodes.tsv.gz"
#>   ..$ phased_vcf: chr "/path/to/het_phased.vcf.gz"
#>   ..$ events    : NULL
```
