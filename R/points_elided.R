#' Shift points around Alaska and Hawaii to the elided area
#'
#' This function will take a SpatialPoints object and shift the points around
#'  Alaska and Hawaii to the elided area from this package.
#'
#' @param sp An object of SpatialPoints class
#' @return An elided version of the original SpatialPoints class
#' @export
points_elided <- function(sp){
  orig_proj <- sp::proj4string(sp)
  # convert it to Albers equal area
  sp <- sp::spTransform(sp, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

  ak_bb   <- readRDS(system.file("extdata/alaska_bb.rda", package="albersusa"))
  #ak_bb   <- readRDS("inst/extdata/alaska_bb.rda")
  ak_poly <- as(raster::extent(as.vector(t(ak_bb))), "SpatialPolygons")
  sp::proj4string(ak_poly) <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

  # Determine which points fall in the Alaska bounding box, subset and remove
  #  from the original points
  ak_l <- sp::over(sp, ak_poly)
  ak   <- sp[!is.na(ak_l),]
  sp   <- sp[is.na(ak_l),]

  # Elide the points, the key here is to set "bb" to what the original
  #  transformation's bounding box was!
  ak    <- maptools::elide(ak,
                           scale=max(apply(ak_bb, 1, diff)) / 2.3,
                           rotate = -50,
                           bb = ak_bb) # NEED the bb option here
  ak    <- maptools::elide(ak, shift = c(-1298669, -3018809)) # bb doesn't matter
  sp::proj4string(ak) <- sp::proj4string(sp)

  hi_bb <- readRDS(system.file("extdata/hawaii_bb.rda", package="albersusa"))
  #hi_bb   <- readRDS("inst/extdata/hawaii_bb.rda")
  hi_poly <- as(raster::extent(as.vector(t(hi_bb))), "SpatialPolygons")
  sp::proj4string(hi_poly) <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

  # Determine which points fall in the Alaska bounding box, subset and remove
  #  from the original points
  hi_l <- sp::over(sp, hi_poly)
  hi   <- sp[!is.na(hi_l),]
  sp   <- sp[is.na(hi_l),]

  hi    <- maptools::elide(hi,
                           rotate = -35,
                           bb = hi_bb) # NEED the bb option here
  hi    <- maptools::elide(hi, shift = c(5400000, -1400000)) # bb doesn't matter
  sp::proj4string(hi) <- sp::proj4string(sp)

  # Bring them back together with original projection
  sp <- rbind(sp, ak, hi)
  sp <- sp::spTransform(sp, CRS(orig_proj))

  return(sp)
}