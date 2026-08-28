\name{spatstat.convert-package}
\alias{spatstat.convert-package}
\alias{spatstat.convert}
\docType{package}
\title{
  Convert Spatial Data Formats
}
\description{
  Contains functions for converting spatial data between formats 
  in the packages \pkg{spatstat}, \pkg{sf}, \pkg{sp} and \pkg{terra}.
}
\details{
  This package provides functions for converting spatial data objects
  between different formats supported in the packages
  \pkg{spatstat}, \pkg{sf}, \pkg{sp} and \pkg{terra}.

  An object \code{X} can be converted to a new class \code{"foo"} using the
  S4 style syntax \code{as(X, "foo")}. If \code{"foo"} is a class in the
  \pkg{spatstat} package, then the conversion can also be written in the
  S3 style \code{as.foo(X)}.

  This package depends on the packages \pkg{spatstat} and \pkg{sp},
  but only Suggests the packages \pkg{sf} and \pkg{terra}.
  In order to convert data to or from a format defined in \pkg{sf},
  the user must load \pkg{sf}. To convert data to or from a format
  defined in \pkg{terra}, the user must load \pkg{terra}. 

  Functions for converting \emph{to} \pkg{spatstat} data types are:
  \tabular{l}{
    \code{\link{as.im.SpatialGridDataFrame}} \\
    \code{\link{as.im.SpatRaster}} \\
    \code{\link{as.linnet.SpatialLines}} \\
    \code{\link{as.linnet.sf}} \\
    \code{\link{as.owin.SpatialGridDataFrame}} \\
    \code{\link{as.owin.SpatialPixelsDataFrame}} \\
    \code{\link{as.owin.SpatialPolygons}} \\
    \code{\link{as.ppp.sf}} \\
    \code{\link{as.ppp.SpatialPoints}} \\
    \code{\link{as.ppp.SpatialPointsDataFrame}} \\
    \code{\link{as.psp.Line}} \\
    \code{\link{as.psp.Lines}} \\
    \code{\link{as.psp.SpatialLines}} \\
    \code{\link{as.psp.SpatialLinesDataFrame}} 
  }

  Functions for converting \emph{from} \pkg{spatstat} data types are:
  \tabular{l}{
    \code{\link{as.SpatialGridDataFrame.im}} \\
    \code{\link{as.SpatialPolygons.owin}} \\
    \code{\link{as.SpatialGridDataFrame.owin}} \\
    \code{\link{as.SpatialPoints.ppp}} \\
    \code{\link{as.SpatialPointsDataFrame.ppp}} \\
    \code{\link{as.SpatialGridDataFrame.ppp}} \\
    \code{\link{as.SpatialLines.psp}} \\
    \code{\link{as.SpatialPolygons.tess}}
  }

}
\author{
  \adrian, \ege, \rolf, \edzer, \roger, \mike, 
  Matthew Lewis, Mathieu Rajerison and \mehdi.
}
\examples{
  ## Create a SpatialPolygons representing a region with a hole
  holey <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(0,1,1,0,0),
    c(0,0,1,1,0))), Polygon(cbind(c(0.6,0.4,0.4,0.6,0.6), 
    c(0.2,0.2,0.4,0.4,0.2)), hole=TRUE)), ID="ho")))
  plot(holey, col="red", pbg="pink")
  ## convert SpatialPolygons -> owin
  hoy <- as(holey, "owin")
  plot(hoy)
  ##
}
\keyword{package}
