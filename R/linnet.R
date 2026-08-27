#' linnet.R
#'
#'  Convert data representing a linear network
#'
#'  as.linnet.SpatialLines
#'  as.linnet.sf
#'
#'    Contributions from: Ege Rubak, Mehdi Moradi
#'    Last edit: 2026/08/26 Adrian Baddeley
#'  
#' ///////////////////////////////////////////////////////////////
#'
#' Base code for converting lists of lines to a linear network.
#' Each line is a list of vertices; successive vertices on a line are joined.
#' 
#' If fuse=TRUE, the code searches for pairs of points with the same (x,y)
#'               coordinates that occur in different lines,
#'               and merges them together as identical vertices of the network.

islistdf <- function(z) {
  is.list(z) && all(
                  sapply(z, is.data.frame) | sapply(z, is.matrix)
                )
}
islistlistdf <- function(z) { is.list(z) && all(sapply(z, islistdf)) }

lines2network <- function(XY, BB=NULL, DF=NULL, fuse=FALSE) {
  ## Expect a list of data frames, or a list of lists of data frames
  if(islistlistdf(XY)) {
    crdlists <- XY
  } else if(islistdf(XY)) {
    crdlists <- list(XY)
  } else stop("XY should be a list of lists of data frames of coordinates",
              call.=FALSE)
  n <- length(crdlists)
  xx <- yy <- numeric(0)
  ii <- jj <- integer(0)
  if(n > 0) {
    ## coordinates of all vertices
    rowcounts <- unname(lapply(crdlists, function(x) sapply(x, nrow)))
    colcounts <- unname(lapply(crdlists, function(x) sapply(x, ncol)))
    if(any(unlist(colcounts) != 2))
      stop("Coordinates should be 2-column matrices", call.=FALSE)
    ## 'rbind' all the matrices of coordinates
    xy <- unlist(lapply(crdlists, function(x) lapply(x, t)))
    xy <- matrix(xy, ncol=2, byrow=TRUE)
    xx <- xy[,1]
    yy <- xy[,2]
    ## construct indices for each level of list in original data
    ii <- rep(seq_along(crdlists), sapply(rowcounts, sum))
    jj <- unlist(lapply(rowcounts, function(x) rep(seq_along(x), as.integer(x))))
    ## check for *repeated* vertices within the same line
    rpt <- c(FALSE, (diff(xx) == 0) & (diff(yy) == 0) & (diff(ii) == 0) & (diff(jj) == 0))
    if(any(rpt)) {
      warning("Repeated vertices (on the same line) were removed", call.=FALSE)
      retain <- !rpt
      xx <- xx[retain]
      yy <- yy[retain]
      ii <- ii[retain]
      jj <- jj[retain]
    }
  }
  ## extract vertices
  if(is.null(BB)) BB <- ripras(xx, yy, shape="rectangle")
  V <- spatstat.geom::ppp(xx, yy, window=BB, check=!fuse)
  nV <- length(xx)
  ## join them
  edges <- NULL
  iii <- jjj <- integer(0)
  if(nV > 1) {
    seqn <- seq_len(nV)
    from <- seqn[-nV]
    to   <- seqn[-1]
    ok   <- diff(ii) == 0 & diff(jj) == 0
    from <- from[ok]
    to   <- to[ok]
    iii  <- ii[c(ok, FALSE)] # indices backward
    jjj  <- jj[c(ok, FALSE)]
    if(fuse) {
      umap <- spatstat.univar::uniquemap(V)
      retain <- (umap == seq_along(umap))
      V <- V[retain]
      renumber <- cumsum(retain)
      from <- renumber[umap[from]]
      to   <- renumber[umap[to]]
    }
    edges <- cbind(from, to)
  } 
  if(!is.null(edges)) {
    up <- (from < to)
    ee <- cbind(ifelse(up, from , to), ifelse(up, to, from))
    if(anyDuplicated(ee)) {
      u <- !duplicated(ee)
      from <- from[u]
      to   <- to[u]
      iii  <- iii[u]
      jjj  <- jjj[u]
    }
  }
  result <- spatstat.linnet::linnet(vertices=V, edges = edges, sparse=TRUE)
  ## attach columns of data
  if(spatstat.geom::nsegments(result) == length(iii)) {
    df <- data.frame(LinesIndex=iii, LineIndex=jjj)
    if(!is.null(DF)) 
      df <- cbind(DF[iii,,drop=FALSE], df)
    spatstat.geom::marks(result$lines) <- df
  } else warning("Internal error: could not map data frame to lines")
  return(result)
}

#' ///////////////////////////////////////////////////////////////////////
#' 
#' as.linnet.SpatialLines
#' Convert 'SpatialLines*' object to spatstat 'linnet' object
#' 
#' For 'SpatialLinesDataFrame', the data columns are copied 
#' to the network as marks associated with the network segments.
#'

as.linnet.SpatialLines <- function(X, ..., fuse=TRUE) {
  needpack("sp", "to handle 'SpatialLines' objects")
  stipulateProjected(X)
  ## extract bounding box to use as window
  bb <- sp::bbox(X)
  BB <- spatstat.geom::owin(bb[1,], bb[2,])
  ## coordinates 
  crdlists <- sp::coordinates(X)
  ## data columns?
  DF <- if(.hasSlot(X, "data")) slot(X, "data") else NULL
  ## convert to network 
  result <- lines2network(crdlists, BB, DF=DF, fuse=fuse)
  return(result)
}

setAs("SpatialLines", "linnet",
      function(from) as.linnet.SpatialLines(from))

setAs("SpatialLinesDataFrame", "linnet",
      function(from) as.linnet.SpatialLines(from))


#' /////////////////////////////////////////////////////////////////
#' 
#' as.linnet.sf
#'

as.linnet.sfc <- as.linnet.sf <- function(X, ..., fuse=TRUE) {
  needpack("sf", "to handle sf objects")
  ## validate and extract geometry
  if(inherits(X, "sf")) {
    g <- sf::st_geometry(X)
  } else if(inherits(X, "sfc")) {
    g <- X
  } else {
    stop("'X' must be an object of class 'sf' or 'sfc'", call.=FALSE)
  }
  ## Check that coordinates are planar
  stipulateProjected(g)
  ## Keep/cast linear geometries
  g <- sf::st_cast(g, "MULTILINESTRING", warn = FALSE)
  g <- sf::st_cast(g, "LINESTRING", warn = FALSE)
  ## Extract coordinates
  crd <- sf::st_coordinates(g)
  ## LINESTRING identifier
  id_col <- if ("L1" %in% colnames(crd)) "L1" else
    stop("Could not identify individual LINESTRING geometries", call.=FALSE)
  ids <- crd[, id_col]
  ## Split coordinates by line
  lines <- split(
    data.frame(x = crd[, "X"], y = crd[, "Y"]),
    ids
  )
  ## convert to linear network
  L <- lines2network(lines, fuse=fuse)
  return(L)
}

setAs("sf", "linnet",
      function(from) as.linnet.sf(from))

setAs("sfc", "linnet",
      function(from) as.linnet.sf(from))


