# mountainplot <img src="figure/mountainplot_logo_150.png" align="right" />

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mountainplot)](https://cran.r-project.org/package=mountainplot)
[![CRAN_Downloads](https://cranlogs.r-pkg.org/badges/mountainplot)](https://cranlogs.r-pkg.org/badges/mountainplot)


Key features:

* Extends lattice graphics to support multi-panel, multi-group mountainplots.

## Installation

```R
# Install the released version from CRAN:
install.packages("mountainplot")

# Install the development version from GitHub:
install.packages("devtools")
devtools::install_github("kwstat/mountainplot")
```

## Vignettes

[Introduction to the mountainplot package](https://rawgit.com/kwstat/mountainplot/master/vignettes/mountainplot_examples.html)

## Usage

```R
require(mountainplot)
data(singer, package = "lattice")
parts <- within(singer, {
section <- voice.part
section <- gsub(" 1", "", section)
section <- gsub(" 2", "", section)
section <- factor(section)
})
# Change levels to logical ordering
levels(parts$section) <- c("Bass","Tenor","Alto","Soprano")
mountainplot(~height|section, data = parts,
             groups=voice.part, type='l',
             layout=c(1,4),
             main="Folded Empirical CDF",
             auto.key=list(columns=4), as.table=TRUE)
```
![mountainplot](figure/mountainplot.png)
