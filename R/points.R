#' spatstat.convert/R/points.R
#'
#'  Conversion of point patterns
#'
#' Last edit: 2026/08/21 Adrian Baddeley

#' (1) sf, sp -> spatstat

as.ppp.sf <- function(X, ..., fatal=TRUE, warn=TRUE) {
  if(!inheritsSF(X))
    stop("Expecting an object of class 'sf' or 'sfc'", call.=FALSE)
  needpack("sf", "to convert 'sf' objects")
  stipulateProjected(X, fatal=fatal, warn=warn)
  Y <- spatstat.geom::as.ppp(sf::st_geometry(X))
  if (sf::st_dimension(X[1, ]) == 2) 
    X <- X[-1, ]
  marks(Y) <- sf::st_drop_geometry(X)
  return(Y)
}

setAs("sf", "ppp", function(from) as.ppp.sf(from))

as.ppp.SpatialPoints <- function(X, W=NULL, ..., fatal=TRUE) {
  needpack("sp", "to convert 'SpatialPoints' objects")
  stipulateProjected(X, fatal=fatal)
  if(is.null(W)) {
    bb <- sp::bbox(X)
    colnames(bb) <- NULL
    W <- spatstat.geom::owin(bb[1,], bb[2,])
  } else {
    W <- as.owin(W)
  }
  cc <- sp::coordinates(X)
  spatstat.geom::ppp(cc[,1], cc[,2], window = W, marks = NULL, check=FALSE)
}

setAs("SpatialPoints", "ppp", function(from) as.ppp.SpatialPoints(from))

#' Mike Sumner 20101011
#' tweaked by Adrian Baddeley 20260820

as.ppp.SpatialPointsDataFrame <- function(X, W=NULL, ..., fatal=TRUE) {
  needpack("sp", "to convert 'SpatialPointsDataFrame' objects")
  stipulateProjected(X, fatal=fatal)
  if(is.null(W)) {
    bb <- sp::bbox(X)
    colnames(bb) <- NULL
    W <- spatstat.geom::owin(bb[1,], bb[2,])
  } else {
    W <- as.owin(W)
  }
  nc <- ncol(X)
  marx <- if(nc == 0) NULL else slot(X, "data")
  cc <- sp::coordinates(X)
  spatstat.geom::ppp(cc[,1], cc[,2], window = W, marks = marx, check=FALSE)
}

setAs("SpatialPointsDataFrame", "ppp", function(from) as.ppp.SpatialPointsDataFrame(from))

#' (2) spatstat -> sp, sf
#' 

as.SpatialPoints.ppp <- function(from) {
  needpack("sp", "to create 'SpatialPoints' objects")
  ## ensure coordinates are not expressed in a multiple of a unit
  from <- spatstat.geom::rescale(from) 
  crds <- cbind(from$x, from$y)
  W <- spatstat.geom::Window(from)
  if(spatstat.geom::is.rectangle(W)) {
    bb <- rbind(W$xrange, W$yrange)
    colnames(bb) <- c("min", "max")
  } else {
    bb <- NULL
  }
  sp::SpatialPoints(coords=crds, bbox=bb)
}

setAs("ppp", "SpatialPoints", as.SpatialPoints.ppp)

as.SpatialPointsDataFrame.ppp <- function(from) {
  needpack("sp", "to create 'SpatialPoints' objects")
  SP <- as(from, "SpatialPoints")
  m <- spatstat.geom::marks(from)
  if(!is.null(m) && !is.data.frame(m)) m <- data.frame(marks=m)
  sp::SpatialPointsDataFrame(SP, m)
}

setAs("ppp", "SpatialPointsDataFrame", as.SpatialPointsDataFrame.ppp)

as.SpatialGridDataFrame.ppp <- function(from) {
  needpack("sp", "to create 'SpatialGridDataFrame' objects")
  w <- spatstat.geom::Window(from)
  if(!spatstat.geom::is.mask(w))
    stop("window is not a binary pixel mask")
  offset <- c(w$xcol[1L], w$yrow[1L])
  cellsize <- c(w$xstep, w$ystep)
  dim <- w$dim[2:1]
  gt <- sp::GridTopology(offset, cellsize, dim)
  wm <- w$m
  m <- t(wm[nrow(wm):1,])
  m[!m] <- NA
  dat <- data.frame(mask = as.vector(m))
  sp::SpatialGridDataFrame(gt, dat)
}

setAs("ppp", "SpatialGridDataFrame", as.SpatialGridDataFrame.ppp)

