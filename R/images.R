#' spatstat.convert/R/images.R
#'
#'     Conversion of pixel images
#'
#' Last edit: 2026/08/21 Adrian Baddeley
#' Contributions: Matthew Lewis 
#' 
#' >>>>>>>>>>>>>>   terra, sp, sf  -> spatstat  <<<<<<<<<<<<<<<<<<<<<<<<

#' SpatRaster -> im

as.im.SpatRaster <- function(X, ...) {
  needpack("terra", "to convert 'SpatRaster' objects")
  if (!terra::hasValues(X))
    stop("values are required in the SpatRaster object", call.=FALSE)
  if (terra::is.rotated(X))
    stop("Cannot coerce because object is rotated. Suggest using rectify()",
         call.=FALSE)
  X <- X[[1]]
  #' bounding box (xmin, xmax, ymin, ymax)
  e <- as.vector(terra::ext(X))
  g <- as.list(X, geom=TRUE)
  if (is.factor(X)) {
    v <- matrix(as.data.frame(X)[, 1L],
                nrow=g$nrows, ncol=g$ncols, byrow=TRUE)
    levX <- levels(X)[[1L]][["label"]]
    v <- factor(v, levels=levX)
  } else {
    v <- as.matrix(X, wide=TRUE)
  }
  #' convert to spatstat indexing order
  v <- spatstat.geom::transmat(v, from = list(x="-i", y="j"), to = "spatstat")
  #' make object
  out <- spatstat.geom::im(v, xrange=e[1:2], yrange=e[3:4])
  return(out)
}

setAs("SpatRaster", "im", function(from) as.im.SpatRaster(from))

#' SpatialGridDataFrame -> im

as.im.SpatialGridDataFrame <- function(X, ...) {
  needpack("sp", "to convert 'SpatialGridDataFrame' objects")
  xi <- sp::as.image.SpatialGridDataFrame(X)
  spatstat.geom::im(t(xi$z), xcol=xi$x, yrow=xi$y)
}

setAs("SpatialGridDataFrame", "im",
      function(from) as.im.SpatialGridDataFrame(from))

#' >>>>>>>>>>>>>>   spatstat -> sp  <<<<<<<<<<<<<<<<<<<<<<<<

#' im -> SpatialGridDataFrame

as.SpatialGridDataFrame.im <- function(from) {
  needpack("sp", "to create 'SpatialGridDataFrame' objects")
  offset <- c(from$xcol[1L], from$yrow[1L])
  cellsize <- c(from$xstep, from$ystep)
  dim <- from$dim[2:1]
  gt <- sp::GridTopology(offset, cellsize, dim)
  fv <- from$v
  v <- t(fv[nrow(fv):1,])
  dat <- data.frame(v = as.vector(v))
  sp::SpatialGridDataFrame(gt, dat)
}

setAs("im", "SpatialGridDataFrame", as.SpatialGridDataFrame.im)

