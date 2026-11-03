# Parse `--key value` and `--flag` arguments

Parse `--key value` and `--flag` arguments

## Usage

``` r
cli_args(
  args = commandArgs(trailingOnly = TRUE),
  defaults = list(),
  usage = NULL
)
```

## Arguments

- args:

  character vector (default `commandArgs(trailingOnly = TRUE)`)

- defaults:

  named list of defaults; values are coerced to the default's type

- usage:

  text printed with `--help`

## Value

named list. With `--help` the usage is printed and a script (`Rscript`)
quits; an interactive session gets the defaults back with attribute
`help = TRUE`

## Examples

``` r
cli_args(c("--dir", "extract", "--cores", "4", "--no-embedding"),
         defaults = list(dir = "", cores = 8))
#> $dir
#> [1] "extract"
#> 
#> $cores
#> [1] 4
#> 
#> $no_embedding
#> [1] TRUE
#> 
```
