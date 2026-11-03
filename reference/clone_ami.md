# Adjusted mutual information of two labelings

AMI (Vinh, Epps & Bailey 2010; arithmetic-mean normalisation,
scikit-learn's default) on the cells labelled in both vectors (NA and ""
dropped): `(MI - E(MI)) / (mean(H(x), H(y)) - E(MI))`, E(MI) under the
hypergeometric (permutation) model.

## Usage

``` r
clone_ami(x, y)
```

## Arguments

- x, y:

  label vectors of equal length

## Value

numeric AMI (1 = identical partitions, ~0 = independent)
