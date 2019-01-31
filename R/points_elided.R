#' Shift points around Alaska and Hawaii to the elided area
#'
#' This function will take a SpatialPoints object or a data frame of coordinates
#' and shift the points around Alaska and Hawaii to the elided area from this package.
#'
#' @param sp An object of SpatialPoints class or a data frame with x (lon) and y (lat)
#' @return An elided version of the original SpatialPoints class or a data frame
#'         depending on what was passed in.
#' @export
points_elided <- function(sp) {

  ret <- "sp"

  if (inherits(sp, "data.frame")) {
    class(sp) <- "data.frame"
    sp <- setNames(sp, c("lon", "lat"))
    sp::coordinates(sp) <- ~lon+lat
    sp::proj4string(sp) <- us_longlat_proj
    ret <- "df"
  }

  orig_proj <- sp::proj4string(sp)
  # convert it to Albers equal area
  sp <- sp::spTransform(sp, sp::CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

  ak_bb <- readRDS(system.file("extdata/alaska_bb.rda", package="albersusa"))
  ak_poly <- as(raster::extent(as.vector(t(ak_bb))), "SpatialPolygons")
  sp::proj4string(ak_poly) <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

  # Determine which points fall in the Alaska bounding box, subset and remove
  #  from the original points
  ak_l <- sp::over(sp, ak_poly)
  ak <- sp[!is.na(ak_l),]

  # sp <- sp[is.na(ak_l),]

  if (length(ak)) {
    # Elide the points, the key here is to set "bb" to what the original
    #  transformation's bounding box was!
    ak <- maptools::elide(
      ak,
      scale=max(apply(ak_bb, 1, diff)) / 2.3,
      rotate = -50,
      bb = ak_bb
    ) # NEED the bb option here
    ak <- maptools::elide(ak, shift = c(-1298669, -3018809)) # bb doesn't matter
    sp::proj4string(ak) <- sp::proj4string(sp)
  }

  hi_bb <- readRDS(system.file("extdata/hawaii_bb.rda", package="albersusa"))
  #hi_bb   <- readRDS("inst/extdata/hawaii_bb.rda")
  # hi_bb <- matrix(c(-160.2471, 18.9117, -154.8066, 22.2356), 2, 2)
  # rownames(hi_bb) <- c("x", "y")
  # colnames(hi_bb) <- c("min", "max")
  hi_poly <- as(raster::extent(as.vector(t(hi_bb))), "SpatialPolygons")
  # sp::proj4string(hi_poly) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  # hi_poly <- sp::spTransform(hi_poly, CRSobj = "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")
  sp::proj4string(hi_poly) <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

  # Determine which points fall in the Alaska bounding box, subset and remove
  #  from the original points
  hi_l <- sp::over(sp, hi_poly)
  hi <- sp[!is.na(hi_l),]
  sp <- sp[is.na(hi_l),]

  if (length(hi)) {
    hi <- maptools::elide(
      hi,
      rotate = -35,
      bb = hi_bb
    ) # NEED the bb option here
    hi <- maptools::elide(hi, shift = c(5400000, -1400000)) # bb doesn't matter
    sp::proj4string(hi) <- sp::proj4string(sp)
  }

  # Bring them back together with original projection
  if (length(ak) && length(hi)) {
    sp <- rbind(sp, ak, hi)
  } else if (length(ak)) {
    sp <- ak
  } else if (length(hi)) {
    sp <- hi
  }

  sp <- sp::spTransform(sp, CRS(orig_proj))

  return(if (ret == "sp") sp else as.data.frame(sp))

}