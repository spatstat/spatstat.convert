#'  spatstat.convert/R/lines.R
#'
#'  Handle lines 
#' 
#'  Last edit: 2026/08/21 Adrian Baddeley
#'  Contributions: Rolf Turner, Adrian Baddeley, Mathieu Rajerison

#' (1) spatstat -> sp
#'
#' psp -> SpatialLines
#' 2011/11/17  Rolf Turner, Adrian Baddeley, Mathieu Rajerison

as.SpatialLines.psp <- local({

  as.SpatialLines.psp <- function(from) {
    needpack("sp", "to create 'SpatialLines' objects")
    ends <- as.data.frame(from)[,1:4]
    ends[,5] <- row.names(ends)
    y <- apply(ends, 1, munch)
    sp::SpatialLines(y)
  }

  ends2line <- function(x) sp::Line(matrix(x, ncol=2, byrow=TRUE))
  munch <- function(z) { sp::Lines(ends2line(as.numeric(z[1:4])), ID=z[5]) }
  
  as.SpatialLines.psp
})

setAs("psp", "SpatialLines", function(from) as.SpatialLines.psp(from))

#' (2) sp -> spatstat
#'
#'  Line -> psp

as.psp.Line <- function(x, ..., window=NULL, marks=NULL, fatal=TRUE) {
  needpack("sp", "to handle 'Line' objects")
  co <- slot(x, "coords")
  df <- as.data.frame(cbind(co[-nrow(co), , drop=FALSE],
                            co[-1L, , drop=FALSE]))
  if(is.null(window)) {
    xrange <- range(co[,1L])
    yrange <- range(co[,2L])
    window <- spatstat.geom::owin(xrange, yrange)
  }
  return(spatstat.geom::as.psp(df, window=window, marks=marks))
}

setAs("Line", "psp", function(from) as.psp.Line(from))
  
#'  Lines -> psp

as.psp.Lines <- function(x, ..., window=NULL, marks=NULL, fatal) {
  needpack("sp", "to handle 'Lines' objects")
  y <- lapply(slot(x, "Lines"), as.psp.Line, window=window)
  z <- do.call(spatstat.geom::superimpose,c(y,list(W=window)))
  if(!is.null(marks))
    spatstat.geom::marks(z) <- marks
  return(z)
}

setAs("Lines", "psp", function(from) as.psp.Lines(from))

#'  SpatialLines -> psp

as.psp.SpatialLines <- function(x, ..., window=NULL, marks=NULL,
                                characterMarks=FALSE, fatal=TRUE) {
  needpack("sp", "to handle 'SpatialLines' objects")
  stipulateProjected(x, fatal=fatal)
  if(is.null(window)) {
    w <- slot(x, "bbox")
    window <- spatstat.geom::owin(w[1,], w[2,])
  }
  lin <- slot(x, "lines")
  y <- lapply(lin, as.psp.Lines, window=window)
  id <- row.names(x)
  if(is.null(marks))
    for (i in seq(y)) 
      spatstat.geom::marks(y[[i]]) <- if(characterMarks) id[i] else factor(id[i])
  #' modified 110401 Rolf Turner
  z <- do.call(spatstat.geom::superimpose, c(y, list(W = window)))
  if(!is.null(marks))
    spatstat.geom::marks(z) <- marks
  return(z)
}

setAs("SpatialLines", "psp", function(from) as.psp.SpatialLines(from))

#'  SpatialLinesDataFrame -> psp

as.psp.SpatialLinesDataFrame <- function(x, ...,
                                         window=NULL, marks=NULL, fatal=TRUE) {
  needpack("sp", "to handle 'SpatialLines' objects")
  stipulateProjected(x, fatal=fatal)
  y <- as(x, "SpatialLines")
  z <- spatstat.geom::as.psp(y, window=window, marks=marks)
  if(is.null(marks)) {
    # extract marks from first column of data frame
    df <- x@data
    if(is.null(df) || (nc <- ncol(df)) == 0)
      return(z)
    if(nc > 1) 
      warning(paste(nc-1, "columns of data frame discarded"))
    marx <- df[,1]
    nseg.Line  <- function(x) { return(nrow(x@coords)-1) }
    nseg.Lines <- function(x) { return(sum(unlist(lapply(x@Lines, nseg.Line)))) }
    nrep <- unlist(lapply(y@lines, nseg.Lines))
    spatstat.geom::marks(z) <- rep(marx, nrep)
  }
  return(z)
}

setAs("SpatialLinesDataFrame", "psp", function(from) as.psp.SpatialLinesDataFrame(from))

