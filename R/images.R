#' conversion of pixel images

as.im.SpatRaster <- function(X, ...) {
  if(!isNamespaceLoaded("terra"))
    stop("Package 'terra' is required for conversion of 'SpatRaster' objects")
  X <- X[[1]]
  e <- as.vector(terra::ext(X))
  g <- as.list(X, geom=TRUE)
  if (is.factor(X)) {
    v <- matrix(as.data.frame(X)[, 1], nrow=g$nrows, ncol=g$ncols, byrow=TRUE)
    v <- v[nrow(X):1, , drop=FALSE]
    v <- factor(v, levels=levels(X))
  } else {
    v <- as.matrix(X, wide=TRUE)
    v <- v[nrow(X):1, , drop=FALSE]
  }
  out <- im(v, xrange=e[1:2], yrange=e[3:4], unitname=g$units)
  return(out)
}

