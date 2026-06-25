# M4MA-group-benchmarking
This repository exists for benchmarking the previous iteration of the Minds for Mobile Agents (M4MA) model with the newest group behaviour changes.

## Background

The old version of the M4MA (v0.1.0) and can be viewed through the following [link](https://github.com/ndpvh/predped) (at the time of creating this repository). The changes which were implement in the new version of the M4MA (v0.3.0) can be viewed through the following [link](https://github.com/ndpvh/predped/group-goals). 

The folders within this repository are named after the new implementations. Namely,
>`archtypes`, 
>`group_goals`, 
>`individual_goals`, 
> and `density_analysis`. 

Each folder contains the respective simulation scripts, GIFs, trace file (.Rds), and plotting scripts. 

## Installation

### Old version of M4MA

Install the `predped` via `remotes`:

``` r
remotes::install_github("ndpvh/predped")
```

To use the package, load it through `library()`:

``` r
library(predped)
```

### New version of M4MA

The new implementations are contained within the **group-goals** branch. Hence,the installation is slightly different.

Install the branch via `remotes`:

``` r
remotes::install_github("ndpvh/predped", ref = "group-goals")
```

To use the package, load it through `library()`:

``` r
library(predped)
```

## Contact

For any help or access to additional files please contact me at:
 > kubojurak@gmail.com

## See also

For more information about the M4MA model and the `predped` package please refer to the following [GitHub Page](https://github.com/ndpvh/predped).