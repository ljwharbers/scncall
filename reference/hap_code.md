# Haplotype codes used in the fragments `hap` column

The Python extraction writes `hap` as 0 = no SNP (unphased), 1 = hap A,
2 = hap B, 3 = ambiguous. `hap_code()` / `hap_label()` convert between
the integer codes and the labels "U" / "A" / "B" / "N" used in R.

## Usage

``` r
hap_code(hap)

hap_label(code)
```

## Arguments

- hap:

  character labels

- code:

  integer codes (or already labels, returned unchanged)

## Value

integer codes
