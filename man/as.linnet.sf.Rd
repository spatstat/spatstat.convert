\name{as.linnet.sf}
\alias{as.linnet.sf}
\alias{as.linnet.sfc}
\alias{coerce,sf,linnet-method}
\alias{coerce,sfc,linnet-method}

\title{
  Convert sf Object to Linear Network
}
\description{
  Convert an object of class \code{sf} or
  \code{sfc} (from package \pkg{sf}),
  representing a collection of polygonal lines,
  into an object of class \code{linnet} (from package \pkg{spatstat}),
  representing a network.
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "sf", to = "linnet")}}
\item{coerce}{\code{signature(from = "sfc", to = "linnet")}}
}
}
\usage{
  \S3method{as.linnet}{sf}(X, \dots)
  \S3method{as.linnet}{sfc}(X, \dots)
}
\arguments{
  \item{X}{
    Object of class \code{sf} or \code{sfc} to be converted.
  }
  \item{\dots}{
    Arguments passed to \code{\link[spatstat.linnet]{as.linnet.psp}}
    controlling the conversion procedure.
  }
}
\details{
  The function \code{as.linnet.sfc} converts an object of class \code{sf}
  or \code{sfc} into an object of class \code{linnet}.
  It is both an S3 method for the \pkg{spatstat} generic function
  \code{\link[spatstat.linnet]{as.linnet}} which can be called in the
  syntax \code{as.linnet(X)}, and an S4 coercion method which can be
  called in the syntax \code{as(X, "linnet")}.

  An object of class \code{sf}
  or \code{sfc} (from package \pkg{sp}) represents
  a list of lists of the coordinates of lines, such as a list of all roads in
  a city. An object of class \code{linnet} in the \pkg{spatstat} package
  represents a linear network, such as a road network.

  The object \code{X} will first be converted into a spatial pattern
  of line segments, an object of class \code{"psp"} in the
  \pkg{spatstat} package. Then
  \code{\link[spatstat.linnet]{as.linnet.psp}} will be called to convert
  the line segment pattern into a linear network.
  Options for this conversion are explained in the help for
  \code{\link[spatstat.linnet]{as.linnet.psp}}.
}
\value{
  An object of class \code{linnet}.
}
\author{
  \adrian.
}
\seealso{
  \code{\link[spatstat.linnet]{as.linnet}}
}
\examples{
  qt <- FALSE
  if(require(sf, quietly=qt)) {
    nc <- st_read(system.file("shape/nc.shp", package="sf"))
    b <- st_sfc(st_cast(st_geometry(nc)[[4]], "MULTILINESTRING"))
    ## convert to 'spatstat' network format
    z <- as.linnet(b)
  }
}
\keyword{spatial}
\keyword{manip}
