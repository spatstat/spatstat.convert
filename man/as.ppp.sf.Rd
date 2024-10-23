\name{as.ppp.sf}
\alias{as.ppp.sf}
\title{
  Convert Point Pattern Data
}
\description{
  Given a dataset of spatial points in the \pkg{sf} package,
  convert it to a spatial point pattern object in the
  \pkg{spatstat} package.
}
\usage{
 \method{as.ppp}{sf}(X, \dots, fatal=TRUE, warn=TRUE)
}
\arguments{
  \item{X}{
    An object of class \code{sf} in the \pkg{sf} package
    representing a point pattern.
  }
  \item{\dots}{Ignored.}
  \item{fatal}{Logical value specifying whether an error should be
    caused if the conversion cannot be performed.}
  \item{warn}{Logical value specifying whether a warning should be
    issued if the conversion cannot be performed.}
}
\details{
  The function \code{\link[spatstat.geom]{as.ppp}} is generic.
  This file describes the method for \code{\link[spatstat.geom]{as.ppp}}
  for objects of class \code{sf} in the \pkg{sf} package.
  
  The object \code{X} is converted to a spatial point pattern
  of class \code{"ppp"}
  recognised by the \pkg{spatstat} family of packages.
}
\value{
  A spatial point pattern (object of class \code{"ppp"})
  recognised by the \pkg{spatstat} family of packages.
}
\author{
  Ege Rubak and Adrian Baddeley and Edzer Pebesma
}
\seealso{
  \code{\link[spatstat.geom]{as.ppp}}.
}
\examples{
  if(FALSE && require(sf) && require(sp)) {
   ## Do not execute: bug in sf:::check_spatstat for fractional version numbers
   ## point pattern dataset in 'sp' format
   data(meuse)
   coordinates(meuse) = ~x+y
   ## convert to 'sf' format
   maas <- st_as_sf(meuse)
   ## convert to 'spatstat' format
   z <- spatstat.convert::as.ppp.sf(maas)
  }
}
\keyword{spatial}
\keyword{manip}
