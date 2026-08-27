\name{as.linnet.sf}
\alias{as.linnet.sf}
\alias{as.linnet.sfc}
\alias{coerce,sf,linnet-method}
\alias{coerce,sfc,linnet-method}
\title{
  Convert 'sf' Object to Linear Network in 'spatstat'
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
  \S3method{as.linnet}{sf}(X, \dots, fuse=TRUE)
  \S3method{as.linnet}{sfc}(X, \dots, fuse=TRUE)
}
\arguments{
  \item{X}{
    Object of class \code{sf} or \code{sfc} to be converted.
  }
  \item{\dots}{
    Ignored.
  }
  \item{fuse}{
    Logical value indicating whether to join different curves
    which have a common vertex.
  }
}
\details{
  These functions convert an object of class \code{sf}
  or \code{sfc} into an object of class \code{linnet}.
  They can be used both as S3 methods for the \pkg{spatstat} generic function
  \code{\link[spatstat.linnet]{as.linnet}} which can be called in the
  syntax \code{as.linnet(X)}, and as S4 coercion methods which can be
  called in the syntax \code{as(X, "linnet")}.

  An object of class \code{sf}
  or \code{sfc} (from package \pkg{sp}) represents
  a list of lists of the coordinates of lines, such as a list of all roads in
  a city. An object of class \code{linnet} in the \pkg{spatstat} package
  represents a linear network, such as a road network.

  If \code{fuse=FALSE}, each line in \code{X}
  will be treated as if it were disconnected from the others.
  The result is a network that consists of many disconnected sub-networks,
  equivalent to the list of lines.
  
  If \code{fuse=TRUE} (the default), the code will
  search for identical pairs of vertices occurring in different
  lines, and will treat them as identical vertices,
  effectively joining the two lines objects at this common
  vertex.
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
