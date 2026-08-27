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
\keyword{internal}
