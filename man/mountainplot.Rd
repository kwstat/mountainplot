\name{mountainplot}
\alias{mountainplot}
\alias{mountainplot.formula}
\alias{mountainplot.numeric}
\title{Mountainplot}
\usage{
mountainplot(x, data, ...)

\method{mountainplot}{formula}(x, data = NULL,
  prepanel = "prepanel.mountainplot", panel = "panel.mountainplot",
  ylab = gettext("Folded Empirical CDF"),
  yscale.components = mountainplotyscale.components, scales = list(y =
  list(alternating = 3)), ...)

\method{mountainplot}{numeric}(x, data = NULL,
  xlab = deparse(substitute(x)), ...)
}
\arguments{
\item{x}{Variable in the data.frame 'data'.}

\item{data}{A data frame}

\item{...}{Other arguments}

\item{prepanel}{The prepanel function.  Default "prepanel.mountainplot".}

\item{panel}{The panel function.  Default "panel.mountainplot".}

\item{ylab}{Vertical axis label.}

\item{yscale.components}{Function for drawing left and right side axes.}

\item{scales}{The "scales" argument used by lattice functions.}

\item{xlab}{Horizontal axis label.}
}
\value{
A lattice object
}
\description{
A mountain plot is similar to an empirical CDF, but _decreases_ from .5 down to 1,
using a separate scale on the right axis.
}
\examples{

data(singer, package = "lattice")
singer <- within(singer, {
section <- voice.part
section <- gsub(" 1", "", section)
section <- gsub(" 2", "", section)
section <- factor(section)
})
mountainplot(~height, data = singer, type='b')
mountainplot(~height|voice.part, data = singer, type='p')
mountainplot(~height|section, data = singer, groups=voice.part, type='l',
auto.key=list(columns=4), as.table=TRUE)

}
\references{
K. L. Monti. (1995)
Folded empirical distribution function curves-mountain plots.
\emph{The American Statistician}, 49, 342--345.
http://www.jstor.org/stable/2684570

Xue, J. H., & Titterington, D. M. (2011). 
The p-folded cumulative distribution function and the mean absolute
deviation from the p-quantile.
\emph{Statistics & Probability Letters}, 81(8), 1179-1182.
}

