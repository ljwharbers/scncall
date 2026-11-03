# Threshold at a false-call budget from null scores

Threshold at a false-call budget from null scores

## Usage

``` r
budget_threshold(null_scores, budget_per_1000 = 1)
```

## Arguments

- null_scores:

  scores of null (event-free) cell-regions

- budget_per_1000:

  allowed false calls per 1,000 cell-regions

## Value

threshold (type-7 quantile at 1 - budget / 1000)
