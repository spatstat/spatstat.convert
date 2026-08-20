
#'  spatstat.convert/R/util.R
#'
#'  Utility functions
#' 
#'  Last edit: 2026/08/20 Adrian Baddeley

inheritsSF <- function(X) { inherits(X, c("sf", "sfc")) }

inheritsSP <- function(X) { identical(attr(class(X), "package"), "sp") }

stipulateProjected <- function(X, fatal=TRUE, warn=TRUE) {
  flat <- if(inheritsSF(X)) {
            !(sf::st_is_longlat(X))
          } else if(inheritsSP(X)) {
            sp::is.projected(X)
          } else TRUE
  if(flat) return(TRUE) 
  whinge <- "Only projected coordinates should be converted to spatstat objects"
  if(fatal) stop(whinge, call.=FALSE)
  if(warn) warning(whinge, call.=FALSE)
  return(FALSE)
}

