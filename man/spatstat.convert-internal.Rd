\name{spatstat.convert-internal}
\title{Internal Functions of the 'spatstat.convert' Package}
\alias{stipulateProjected}
\alias{inheritsSF}
\alias{inheritsSP}
\alias{owin2Polygons}
\alias{needpack}
\alias{islistdf}
\alias{islistlistdf}
\alias{lines2network}
\description{
  Internal functions of the \pkg{spatstat.convert} package.
}
\usage{
  inheritsSF(X)
  inheritsSP(X)
  stipulateProjected(X, fatal, warn)
  owin2Polygons(x, id)
  needpack(pkg, why)
  islistdf(z)
  islistlistdf(z)
  lines2network(XY, BB, DF, fuse)
}
\details{
  These internal functions should not be called directly by the user.
  They may change at any time.
}
\value{
  \code{inheritsSF}, \code{inheritsSP}, \code{islistdf} and
  \code{islistlistdf} return a single logical value.
  \code{stipulateProjected} and \code{needpack} either
  return the value \code{TRUE} (invisibly), or cause an error.
  \code{owin2Polygons} returns an object of class \code{"Polygons"}
  as defined in the \pkg{sp} package.
  \code{lines2network} returns a linear network
  (object of class \code{"linnet"} as defined in the \pkg{spatstat} package).
}
\keyword{internal}
