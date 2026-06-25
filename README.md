# M4MA-group-benchmarking
This repository exists as a collection of results comparing old vs improved social dynamics in M4MA. 

The folders within this repository are named after the new implementations of group dynamics in the M4MA (0.3.0). Namely, `archtypes`, `group_goals`, `individual_goals`, and `density_analysis`. Each folder contains the respective simulation scripts, GIFs, trace files (.Rds), and plotting scripts. 

# Installation

## Old version of M4MA

Install the `predped` via `remotes`:

``` r
remotes::install_github("ndpvh/predped")
```

To use the package, load it through `library()`:

``` r
library(predped)
```

## New version of M4MA

The new implementations are contained within the group-goals branch. Hence the installation is slightly different.

Install the branch via `remotes`:

``` r
remotes::install_github("ndpvh/predped", ref = "group-goals")
```

To use the package, load it through `library()`:

``` r
library(predped)
```