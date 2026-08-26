\name{as.im.SpatialGridDataFrame}
\alias{as.im.SpatialGridDataFrame}
\alias{coerce,SpatialGridDataFrame,im-method}
\alias{as.SpatialGridDataFrame.im}
\alias{coerce,im,SpatialGridDataFrame-method}
\title{Conversion Between Raster Images in the 'sp' and 'spatstat' Packages}
\description{
  Functions to convert between raster image formats in the
  \pkg{spatstat} and \pkg{sp} packages.
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "im")}}
    \item{coerce}{\code{signature(from = "im", to = "SpatialGridDataFrame")}}
  }
}
\usage{
  \S3method{as.im}{SpatialGridDataFrame}(X, \dots)
  as.SpatialGridDataFrame.im(from)
}
\arguments{
  \item{X, from}{object to coerce from}
  \item{\dots}{Ignored.}
}
\details{
  A \code{SpatialGridDataFrame} object may contain several columns of 
  data such that several values are associated with each grid cell.
  In contrast an
  \code{im} object can only contain a single variable value for each cell. In
  \code{as.im.SpatialGridDataFrame()} the first data column is used. To convert 
  another column to \code{im} format simply extract this column first
  as shown in
  the example below.
}
\section{Warning}{
  In \pkg{spatstat} all spatial objects are assumed to be planar. This means
  that \pkg{spatstat} is not designed to work directly with geographic
  (longitude and latitude) coordinates. If a \pkg{sp} object is declared to
  have geographic (unprojected) coordinates \pkg{maptools} refuses to convert
  directly to \pkg{spatstat} format. Rather, these should be projected first
  using e.g. \code{\link[sp]{spTransform}}. If you know what you are doing, and
  really want to force coercion, you can overwrite the \code{proj4string} of the
  \pkg{sp} object with \code{NA}, \code{proj4string(x) <- CRS(NA)}, which
  will fool the system to think that the data is in local planar coordinates.
  This is probably not a good idea!
}
\seealso{
  Other converters between \pkg{sp} and \pkg{spatstat}:
  \code{\link{as.ppp.SpatialPoints}},
  \code{\link{as.psp.SpatialLines}},
  \code{\link{as.owin.SpatialPolygons}},
  \code{\link{as.SpatialPolygons.tess}}.
}
\author{
  \edzer and \roger. Adapted by \adrian.
}
\examples{
run <- TRUE
qt <- FALSE
% if (require("sp", quietly=qt)) run <- TRUE
if (run) {
  ## Extract an example SpatialGridDataFrame and plot it
  data(meuse.grid) # A data.frame
  gridded(meuse.grid) = ~x+y # Now a SpatialPixelsDataFrame
  fullgrid(meuse.grid) <- TRUE # Finally a SpatialGridDataFrame
  mg_dist <- meuse.grid["dist"] # A SpatialGridDataFrame with a single column
  image(mg_dist, axes=TRUE)
  ## Convert to im format and plot it
  mg_im <- as(mg_dist, "im")
  \dontrun{
   plot(mg_im)
  }
  ## Convert back to SpatialGridDataFrame and plot it again
  mg2 <- as.SpatialGridDataFrame.im(mg_im)
  \dontrun{
   image(mg2, axes=TRUE)
  }
}
run <- run && require(terra, quietly=qt)
if (run) {
  ## Convert SpatialGridDataFrame -> SpatRaster -> im and plot it
  r <- as(mg2, "SpatRaster")
  rim <- as.im(r)
  plot(rim)
  ## image with categorical values
  rr <- rast(nrows=2, ncols=3)
  values(rr) <- factor(letters[11:16])
  ii <- as.im(rr)
  plot(ii)
}
}
\keyword{spatial}
\keyword{manip}
