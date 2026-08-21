#' spatstat.convert/R/owin.R
#'
#'     Conversion of windows
#'
#' Last edit: 2026/08/21 Adrian Baddeley
#' Contributions: Mike Sumner 20101011
#' 
#' >>>>>>>>>>>>>  sp -> spatstat <<<<<<<<<<<<<<<<<<<<<<<<<<<<

#' SpatialPolygons -> owin

as.owin.SpatialPolygons <- function(W, ..., fatal=TRUE) {
  needpack("sp", "to convert 'SpatialPolygons' objects")
  if(!inherits(W, "SpatialPolygons"))
    stop("W should be an object of class SpatialPolygons", call.=FALSE)
  stipulateProjected(W, fatal=fatal)
  pls <- slot(W, "polygons")
  nParts <- sapply(pls, function(x) length(slot(x, "Polygons")))
  nOwin <- sum(nParts)
  if (nOwin == 1) {
    pl <- slot(pls[[1]], "Polygons")
    crds <- slot(pl[[1]], "coords")
    colnames(crds) <- c("x", "y")
    rD <- pl[[1]]@ringDir
    if (rD == 1) crds <- crds[nrow(crds):1,]
    crds <- crds[-nrow(crds),]
    result <- spatstat.geom::owin(poly=list(x=crds[,1], y=crds[,2]))
  } else if (nOwin > 1) {
    opls <- vector(mode="list", length=nOwin)
    io <- 1
    for (i in seq(along=pls)) {
      pl <- slot(pls[[i]], "Polygons")
      for (j in 1:nParts[i]) {
        crds <- slot(pl[[j]], "coords")
        colnames(crds) <- c("x", "y")
        rD <- slot(pl[[j]], "ringDir") # sp:::.spFindCG(crds)$rD
        hole <- slot(pl[[j]], "hole")
        if (rD == -1 && hole) crds <- crds[nrow(crds):1,]
        else if (rD == 1 && !hole) crds <- crds[nrow(crds):1,]
        crds <- crds[-nrow(crds),]
        opls[[io]] <- list(x=crds[,1], y=crds[,2])
        io <- io+1
      }
    }
    result <- if(spatstat.geom::spatstat.options("checkpolygons")) {
                spatstat.geom::owin(poly=opls)
              } else {
                #' 070718 added check avoidance
                bb <- sp::bbox(W)
                spatstat.geom::owin(bb[1,], bb[2,],
                                    poly = opls,
                                    check=FALSE)
              }
  } else {
    stop("no valid polygons")
  }
  return(result)
}

setAs("SpatialPolygons", "owin", function(from) as.owin.SpatialPolygons(from))

#' SpatialGridDataFrame -> owin

as.owin.SpatialGridDataFrame <- function(W, ..., fatal=TRUE) {
  needpack("sp", "to convert 'SpatialGridDataFrame' objects")
  stipulateProjected(W, fatal=fatal)
  V <- suppressMessages(as(W, "matrix"))
  m <- t(!is.na(V))
  bb <- sp::bbox(W)
  spatstat.geom::owin(bb[1,], bb[2,], mask = m[nrow(m):1,])
}

setAs("SpatialGridDataFrame", "owin", function(from) as.owin.SpatialGridDataFrame(from))

#' SpatialPixelsDataFrame -> owin

as.owin.SpatialPixelsDataFrame <- function(W, ..., fatal=TRUE) {
  needpack("sp", "to convert 'SpatialPixelsDataFrame' objects")
  stipulateProjected(W, fatal=fatal)
  m = t(!is.na(as(W, "matrix")))
  bb <- sp::bbox(W)
  spatstat.geom::owin(bb[1,], bb[2,], mask = m[nrow(m):1,])
}

setAs("SpatialPixelsDataFrame", "owin", function(from) as.owin.SpatialPixelsDataFrame(from))


#' >>>>>>>>>>>  spatstat -> sp  <<<<<<<<<<<<<<<<<<<<<<<<<<<

owin2Polygons <- local({

  owin2Polygons <- function(x, id="1") {
    stopifnot(spatstat.geom::is.owin(x))
    x <- spatstat.geom::as.polygonal(x)
    pieces <- lapply(x$bdry, handle) 
    z <- sp::Polygons(pieces, id)
    return(z)
  }

  handle <- function(p) {
    ## close up the polygon
    xy <- cbind(c(p$x, p$x[1L]),
                c(p$y, p$y[1L]))
    ## determine whether it is a hold
    ho <- spatstat.utils::is.hole.xypolygon(p)
    ## pass to 'sp'
    sp::Polygon(coords = xy, hole = ho)
  }

  owin2Polygons
})

#' tess -> SpatialPolygons

as.SpatialPolygons.tess <- function(from) {
  needpack("sp", "to create 'SpatialPolygons' objects")
  stopifnot(spatstat.geom::is.tess(from))
  y <- spatstat.geom::tiles(from)
  nam <- names(y)
  z <- list()
  for(i in seq(y)) {
    zi <- try(owin2Polygons(y[[i]], nam[i]), silent=TRUE)
    if (inherits(zi, "try-error")) {
      warning(paste("tile", i, "defective\n", as.character(zi)))
    } else {
      z[[i]] <- zi
    }
  }
  return(sp::SpatialPolygons(z))
}

setAs("tess", "SpatialPolygons", function(from) as.SpatialPolygons.tess(from))

#' owin -> SpatialPolygons

as.SpatialPolygons.owin <- function(from) {
  needpack("sp", "to create 'SpatialPolygons' objects")
  stopifnot(spatstat.geom::is.owin(from))
  y <- owin2Polygons(from)
  z <- sp::SpatialPolygons(list(y))
  return(z)
}

setAs("owin", "SpatialPolygons", as.SpatialPolygons.owin)

#' owin -> SpatialGridDataFrame

as.SpatialGridDataFrame.owin <- function(from) {
  needpack("sp", "to create 'SpatialGridDataFrame' objects")
  from <- spatstat.geom::as.mask(from) 
  offset <- c(from$xcol[1L], from$yrow[1L])
  cellsize <- c(from$xstep, from$ystep)
  dim <- from$dim[2:1]
  gt <- sp::GridTopology(offset, cellsize, dim)
  fm <- from$m
  m <- t(fm[nrow(fm):1,])
  m[!m] <- NA
  dat <- data.frame(mask = as.vector(m))
  sp::SpatialGridDataFrame(gt, dat)
}

setAs("owin", "SpatialGridDataFrame", as.SpatialGridDataFrame.owin)



