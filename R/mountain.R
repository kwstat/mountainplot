# mountainplot.r
# Time-stamp: c:/x/rpack/kw/R/fcdf.r

#' Mountainplot
#' 
#' A mountain plot is similar to an empirical CDF, but _decreases_ from .5 down
#' to 1, using a separate scale on the right axis.
#' 
#' @param x Variable in the data.frame 'data'.
#' @param data A data frame
#' @param ... Other arguments
#' @param prepanel The prepanel function.  Default "prepanel.mountainplot".
#' @param panel The panel function.  Default "panel.mountainplot".
#' @param ylab Vertical axis label.
#' @param yscale.components Function for drawing left and right side axes.
#' @param scales The "scales" argument used by lattice functions.
#' @param xlab Horizontal axis label.
#' @return A lattice object
#' @references
#' K. L. Monti. (1995).
#' Folded empirical distribution function curves-mountain plots.
#' \emph{The American Statistician}, 49, 342--345.
#' http://www.jstor.org/stable/2684570
#' 
#' Xue, J. H., & Titterington, D. M. (2011).  The p-folded cumulative
#' distribution function and the mean absolute deviation from the p-quantile.
#' \emph{Statistics & Probability Letters}, 81(8), 1179-1182.
#' 
#' @examples
#' 
#' data(singer, package = "lattice")
#' singer <- within(singer, {
#' section <- voice.part
#' section <- gsub(" 1", "", section)
#' section <- gsub(" 2", "", section)
#' section <- factor(section)
#' })
#' mountainplot(~height, data = singer, type='b')
#' mountainplot(~height|voice.part, data = singer, type='p')
#' mountainplot(~height|section, data = singer, groups=voice.part, type='l',
#' auto.key=list(columns=4), as.table=TRUE)
#' 
#' @export
mountainplot <- function (x, data, ...)
  UseMethod("mountainplot")

mountainplotyscale.components <- function(...) {
  ans <- yscale.components.default(...)
  ans$right <- ans$left
  foo <- ans$right$labels$at
  ans$right$labels$labels <- as.character(1-foo)
  ans
}

#' @rdname mountainplot
#' @import lattice
#' @export
mountainplot.formula <- 
  function(x, data = NULL,
           prepanel = "prepanel.mountainplot",
           panel = "panel.mountainplot",
           ylab = gettext("Folded Empirical CDF"),
           yscale.components = mountainplotyscale.components,
           scales = list(y = list(alternating = 3)),
           ...) {
  ccall <- match.call()
  ocall <- sys.call(sys.parent())
  ocall[[1]] <- quote(mountainplot)
  ccall$data <- data
  ccall$prepanel <- prepanel
  ccall$panel <- panel
  ccall$ylab <- ylab
  ccall$yscale.components <- yscale.components
  ccall$scales <- scales
  ccall[[1]] <- quote(lattice::densityplot)  # Why...?
  ans <- eval.parent(ccall)
  ans$call <- ocall
  ans
}

#' @rdname mountainplot
#' @export
mountainplot.numeric <- function (x, data = NULL, 
                                  xlab = deparse(substitute(x)), ...) {
    ccall <- match.call()
    ocall <- sys.call(sys.parent())
    ocall[[1]] <- quote(mountainplot)
    if (!is.null(ccall$data))
        warning("explicit 'data' specification ignored")
    ccall$data <- list(x = x)
    ccall$xlab <- xlab
    ccall$x <- ~x
    ccall[[1]] <- quote(mountainplot)  # See note from Felix Andrews
    ans <- eval.parent(ccall)
    ans$call <- ocall
    ans
}



#' The prepanel function for mountainplot
#' 
#' The prepanel function for mountainplot
#' 
#' 
#' @param x The data to be plotted.
#' @param ... Other arguments
#' @import stats
#' @export
prepanel.mountainplot <- function (x, ...) {
  # We could possibly just do: importFrom stats qunif
  # But the user might want other distributions
  ans <- prepanel.default.qqmath(x, distribution = qunif)
  with(ans, list(xlim = ylim, ylim = c(0, .5), dx = dy, dy = dx))
}



#' The panel function for mountainplot
#' 
#' The panel function for mountainplot
#' 
#' 
#' @param x The data to be plotted.
#' @param type The type of ecdf line to use.  Default is 's' square.
#' @param groups Variable to use for grouping
#' @param ref If TRUE, draw horizontal reference lines at 0,1
#' @param ... Other arguments
#' @export
panel.mountainplot <- function (x, type = "s",
                                groups = NULL,
                                ref = TRUE, ...) {
  reference.line <- trellis.par.get("reference.line")
  if (ref) {
    reference.line <- trellis.par.get("reference.line")
    do.call(panel.abline, c(list(h = c(0, 1)), reference.line))
  }
  x <- as.numeric(x)
  distribution <- qunif
  nobs <- sum(!is.na(x))
  if (!is.null(groups)) {
    panel.superpose(x, y = NULL, type = type,
                    distribution = distribution, groups= groups,
                    panel.groups = panel.mountainplot, ...)
  }
  else if (nobs) {
    ypos <- seq_len(nobs)/(nobs+1)
    ypos <- ifelse(ypos<=.5, ypos, 1-ypos)
    panel.xyplot(x = sort(x), y = ypos, type = type, ...)
    panel.abline(h = c(.1,.25), col=reference.line$col, lty=2)
  }
}
