
#'  spatstat.convert/R/util.R
#'
#'  Utility functions
#' 
#'  Last edit: 2026/08/25 Adrian Baddeley

inheritsSF <- function(X) { inherits(X, c("sf", "sfc")) }

inheritsSP <- function(X) { identical(attr(class(X), "package"), "sp") }

stipulateProjected <- function(X, fatal=FALSE, warn=TRUE) {
  knowncurved <- if(inheritsSF(X)) {
                   isTRUE(sf::st_is_longlat(X))
                 } else if(inheritsSP(X)) {
                   isFALSE(sp::is.projected(X))   # e.g. NA is possible
                 } else FALSE
  if(!knowncurved) return(TRUE) 
  whinge <- "Only projected coordinates should be converted to spatstat objects"
  if(fatal) stop(whinge, call.=FALSE)
  if(warn) warning(whinge, call.=FALSE)
  return(FALSE)
}

needpack <- function(pkg, why) {
  spatstat.geom::needpackage(pkg, purpose=why)
}
