# Path of the hg38 centromere table shipped with the package

The Battenberg `chromosome_coordinates_hg38_chr.txt` coordinates
(columns chr, start, cen.left.base, cen.right.base, end; chrX as
`chr23`), copied into `inst/extdata/centromeres_hg38.tsv`. It is the
default `centromeres` of
[`cell_features()`](https://ljwharbers.github.io/scphasedcn/reference/cell_features.md),
[`call_scn()`](https://ljwharbers.github.io/scphasedcn/reference/call_scn.md)
and
[`annotate_arms()`](https://ljwharbers.github.io/scphasedcn/reference/annotate_arms.md).

## Usage

``` r
hg38_centromeres()
```

## Value

file path

## Examples

``` r
head(data.table::fread(hg38_centromeres()))
#>       chr start cen.left.base cen.right.base       end
#>    <char> <int>         <int>          <int>     <int>
#> 1:   chr1     1     122026460      125184587 248956422
#> 2:   chr2     1      92188146       94090557 242193529
#> 3:   chr3     1      90772459       93655574 198295559
#> 4:   chr4     1      49708101       51743951 190214555
#> 5:   chr5     1      46485901       50059807 181538259
#> 6:   chr6     1      58553889       59829934 170805979
```
