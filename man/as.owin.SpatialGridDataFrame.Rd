\name{as.owin.SpatialGridDataFrame}
\alias{as.owin.SpatialGridDataFrame}
\alias{coerce,SpatialGridDataFrame,owin-method}
\alias{as.owin.SpatialPixelsDataFrame}
\alias{coerce,SpatialPixelsDataFrame,owin-method}
\alias{as.owin.SpatialPolygons}
\alias{coerce,SpatialPolygons,owin-method}
\alias{as.SpatialPolygons.owin}
\alias{coerce,owin,SpatialPolygons-method}
\alias{as.SpatialGridDataFrame.owin}
\alias{coerce,owin,SpatialGridDataFrame-method}
\title{Coercion Between 'spatstat' Observation Windows and 'sp' Formats}
\description{
  Functions to convert between observation window (\code{owin}) objects
  in the \pkg{spatstat} package and various formats in the \pkg{sp} package.
  Coercion can use the S3 or S4 syntax.
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "SpatialPolygons", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialPixelsDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "owin", to = "SpatialPolygons")}}
}
}

\usage{
\S3method{as.owin}{SpatialPolygons}(W, \dots, fatal=TRUE)
\S3method{as.owin}{SpatialGridDataFrame}(W, \dots, fatal=TRUE)
\S3method{as.owin}{SpatialPixelsDataFrame}(W, \dots, fatal=TRUE)
as.SpatialPolygons.owin(from)
as.SpatialGridDataFrame.owin(from)
}
\arguments{
  \item{W}{
    Object of class \code{SpatialPolygons},
    \code{SpatialGridDataFrame} or \code{SpatialPixelsDataFrame}
    in the \pkg{sp} package.
  }
  \item{from}{
    Object of class \code{owin} in the \pkg{spatstat} package.
  }
  \item{\dots}{ignored}
  \item{fatal}{Logical value specifying whether conversion errors
    should cause a fatal error.}
}

\section{Warning}{
  In \pkg{spatstat} all spatial objects are assumed to be planar. This means
  that \pkg{spatstat} is not designed to work directly with geographic
  (longitude and latitude) coordinates. If a \pkg{sp} object is declared to
  have geographic (unprojected) coordinates \pkg{maptools} refuses to convert
  directly to \pkg{spatstat} format. Rather, these should be projected first
  using e.g. \code{\link[sp]{spTransform}}. If you know what you are doing, and
  really want to force coercion, you can overwrite the \code{proj4string} of the
  \pkg{sp} object with an empty string, \code{proj4string(x) <- ""}, which
  will fool the system to think that the data is in local planar coordinates.
  This is probably not a good idea!
}
\details{
  These functions convert an object of class \code{owin} in the
  \pkg{spatstat} package into an object of class \code{SpatialPolygons},
  \code{SpatialGridDataFrame} or \code{SpatialPixelsDataFrame}
  in the \pkg{sp} package, and vice versa.
  
  An observation window object of class \code{owin} in the
  \pkg{spatstat} packages defines a planar region. It is
  typically used to represent a sampling region where data were
  observed. It comes in three different
  formats: a simple rectangle, a polygon (vector format) or a binary
  mask (TRUE/FALSE grid; raster format).
  These can all be coerced to polygonal form internally in
  \pkg{spatstat} and then converted to \code{SpatialPolygons}, which is what
  \code{as.SpatialPolygons.owin()} does. For objects of class
  \code{SpatialPolygons} (and \code{SpatialPolygonsDataFrame}) the \pkg{sp}
  polygons are simply extracted and cast into \pkg{spatstat}'s polygon format
  inside the \code{owin} object. For \code{SpatialPixelsDataFrame} and
  \code{SpatialGridDataFrame} the grid is extracted and cast into
  \pkg{spatstat}'s mask format inside the \code{owin} object.
  In all cases, any data apart from the
  spatial region itself are discarded.
}
\note{
  When coercing a SpatialPolygons object to an owin object, full 
  topology checking is enabled by default. To avoid checking, set 
  \code{spatstat.options(checkpolygons=FALSE)}.
  To perform the checking later, \code{owinpolycheck(W, verbose=TRUE)}.
}
\author{\edzer and \roger. Adapted by \adrian.}
\seealso{
  \code{\link{as.SpatialPolygons.tess}}
}
\examples{
run <- FALSE
if (require("sp", quietly=TRUE)) run <- TRUE
if (run) {
  ## SpatialPixelsDataFrame -> owin
  data(meuse.grid) # A data.frame
  gridded(meuse.grid) = ~x+y # Now a SpatialPixelsDataFrame
  mg_owin <- as(meuse.grid, "owin")
  mg_owin
  ## SpatialGridDataFrame -> owin
  fullgrid(meuse.grid) <- TRUE # Now a SpatialGridDataFrame
  mg_owin2 <- as(meuse.grid, "owin")
  ## SpatialPolygons region with a hole
  ho_sp <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(0,1,1,0,0),
    c(0,0,1,1,0))), Polygon(cbind(c(0.6,0.4,0.4,0.6,0.6), 
    c(0.2,0.2,0.4,0.4,0.2)), hole=TRUE)), ID="ho")))
  plot(ho_sp, col="red", pbg="pink")
  ## SpatialPolygons -> owin
  ho <- as(ho_sp, "owin")
  plot(ho)
  ## Define owin directly and check they are identical
  ho_orig <- owin(poly=list(list(x=c(0,1,1,0), y=c(0,0,1,1)),
    list(x=c(0.6,0.4,0.4,0.6), y=c(0.2,0.2,0.4,0.4))))
  identical(ho, ho_orig)
  ## owin -> SpatialPolygons
  ho_sp1 <- as(ho, "SpatialPolygons")
  all.equal(ho_sp, ho_sp1, check.attributes=FALSE)
}
}
\keyword{spatial}
\keyword{manip}
