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
%  It depends on the \pkg{spatstat} package
%  and Suggests the other packages.
  
  An object \code{X} can be converted to a new class \code{"foo"} using the
  S4 style syntax \code{as(X, "foo")}. If \code{"foo"} is a class in the
  \pkg{spatstat} package, then the conversion can also be written in the
  S3 style \code{as.foo(X)}.

  Functions for converting \emph{to} \pkg{spatstat} data types:
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

  Functions for converting \emph{from} \pkg{spatstat} data types:
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
  \adrian, \ege, \rolf, \edzer, \roger, \mike, \mehdi,
  Matthew Lewis and Mathieu Rajerison.
}
\keyword{package}
