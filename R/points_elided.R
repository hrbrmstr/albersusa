#' Shift points around Alaska and Hawaii to the elided area
#'
#' This function will take a SpatialPoints object or a data frame of coordinates
#' and shift the points around Alaska and Hawaii to the elided area from this package,
#' leaving the other points intact.
#'
#' @param sp An object of SpatialPoints class or a data frame with x (`lon`) and y (`lat`)
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

  hi_bb <- readRDS(system.file("extdata/hawaii_bb.rda", package="albersusa"))
  hi_poly <- as(raster::extent(as.vector(t(hi_bb))), "SpatialPolygons")
  sp::proj4string(hi_poly) <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

  spl <- vector("list", length(sp))

  for (idx in seq_along(sp)) {

    tmp <- sp[idx]

    if (!is.na(sp::over(tmp, ak_poly))) {
      tmp <- maptools::elide(tmp, scale = max(apply(ak_bb, 1, diff)) / 2.3, rotate = -50, bb = ak_bb)
      tmp <- maptools::elide(tmp, shift = c(-1298669, -3018809))
    } else if (!is.na(sp::over(tmp, hi_poly))) {
      tmp <- maptools::elide(tmp, rotate = -35, bb = hi_bb)
      tmp <- maptools::elide(tmp, shift = c(5400000, -1400000))
    }

    spl[[idx]] <- sp::coordinates(tmp)

  }

  sp <- do.call(rbind, spl)
  rownames(sp) <- 1:nrow(sp)
  sp <- sp::SpatialPoints(sp, proj4string = sp::CRS(orig_proj))

  return(if (ret == "sp") sp else as.data.frame(sp))

}
