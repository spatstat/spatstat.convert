\name{as.psp.SpatialLines}
\alias{as.psp.Line}
\alias{coerce,Line,psp-method}
\alias{as.psp.Lines}
\alias{coerce,Lines,psp-method}
\alias{as.psp.SpatialLines}
\alias{coerce,SpatialLines,psp-method}
\alias{as.psp.SpatialLinesDataFrame}
\alias{coerce,SpatialLinesDataFrame,psp-method}
\alias{as.SpatialLines.psp}
\alias{coerce,psp,SpatialLines-method}

\title{Coercion between sp objects and spatstat psp objects}
\description{
Functions to convert between \pkg{spatstat}s planar segment pattern (\code{psp})
format and various \pkg{sp} line formats. S4-style \code{as()} coercion can be
used as well.
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "Line", to = "psp")}}
\item{coerce}{\code{signature(from = "Lines", to = "psp")}}
\item{coerce}{\code{signature(from = "SpatialLines", to = "psp")}}
\item{coerce}{\code{signature(from = "SpatialLinesDataFrame", to = "psp")}}
\item{coerce}{\code{signature(from = "psp", to = "SpatialLines")}}
}
}

\usage{
\S3method{as.psp}{Line}(x, \dots, window=NULL, marks=NULL, fatal)
\S3method{as.psp}{Lines}(x, \dots, window=NULL, marks=NULL, fatal)
\S3method{as.psp}{SpatialLines}(x, \dots, window=NULL, marks=NULL,
                  characterMarks=FALSE, fatal)
\S3method{as.psp}{SpatialLinesDataFrame}(x, \dots, window=NULL,
                  marks=NULL, fatal)
as.SpatialLines.psp(from)
}
\arguments{
  \item{x,from}{object to coerce from}
  \item{\dots}{ignored}
  \item{window}{window of class \code{owin} as defined in the spatstat package}
  \item{marks}{marks as defined in the spatstat package}
  \item{characterMarks}{default FALSE, if TRUE, do not convert NULL marks to factor from character}
  \item{fatal}{formal coercion argument; ignored}
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
\author{\edzer and \roger}
\examples{
  data(meuse.riv)
  mr <- Line(meuse.riv)
  mr_psp <- as(mr, "psp")
  mr_psp
  plot(mr_psp)
  xx_back <- as(mr_psp, "SpatialLines")
  plot(xx_back)
}
\keyword{spatial}
