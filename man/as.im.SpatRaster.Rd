\name{as.im.SpatRaster}
\alias{as.im.SpatRaster}
\title{
  Convert `terra' Raster Image to `spatstat' Image 
}
\description{
  Given a raster image in the \code{raster} format of the \pkg{terra}
  package, convert it to a pixel image of class \code{im} in the
  \pkg{spatstat} package.
}
\usage{
 \method{as.im}{SpatRaster}(X, \dots)
}
\arguments{
  \item{X}{
    A raster image object of class \code{raster} in the \pkg{terra} package.
  }
  \item{\dots}{Ignored.}
}
\details{
  The function \code{\link[spatstat.geom]{as.im}} is generic.
  This file describes the method for \code{\link[spatstat.geom]{as.im}}
  for objects of class \code{"SpatRaster"} in the \pkg{terra} package.
  
  The object \code{X} is converted to a pixel image of class \code{"im"}
  recognised by the \pkg{spatstat} family of packages.
}
\value{
  A pixel image object of class \code{"im"} recognised by the
  \pkg{spatstat} family of packages.
}
\author{
  Robert Hijmans, Ege Rubak and Adrian Baddeley.
}
\seealso{
  \code{\link[spatstat.geom]{as.im}}.

  The reverse operation is \code{\link[terra]{rast}}.
}
\examples{
  if(require(terra)) {
    f <- system.file("ex/elev.tif", package="terra")
    x <- rast(f)
    plot(x)
    z <- as.im(x)
    plot(z)
  }
}
\keyword{spatial}
\keyword{manip}
