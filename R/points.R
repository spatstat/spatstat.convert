
as.ppp.sf <- function(X, ..., fatal=TRUE, warn=TRUE) {
  forbid.longlat(X, fatal=fatal, warn=warn)
  Y <- spatstat.geom::as.ppp(st_geometry(X))
  if (sf::st_dimension(X[1, ]) == 2) 
    X <- X[-1, ]
  marks(Y) <- sf::st_drop_geometry(X)
  return(Y)
}

