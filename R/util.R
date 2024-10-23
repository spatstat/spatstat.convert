
forbid.longlat <- function(X, fatal=TRUE, warn=TRUE) {
  if(isTRUE(sf::st_is_longlat(X))) {
    whinge <- "Only projected coordinates should be converted to spatstat objects"
    if(fatal) stop(whinge, call.=FALSE)
    if(warn) warning(whinge, call.=FALSE)
    return(FALSE)
  }
  return(invisible(TRUE))
}
    
