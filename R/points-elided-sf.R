#' Shift points around Alaska and Hawaii to the elided area
#'
#' This function will take an {sf} object or a data frame of coordinates
#' and shift the points around Alaska and Hawaii to the elided area from this package,
#' leaving the other points intact.
#'
#' @param {sfin} An object of SpatialPoints class or a data frame with x (`lon`) and y (`lat`)
#' @return An elided version of the original {sf} class
#' @export
points_elided_sf <- function(sfin) {

  orig_crs <- st_crs(sfin)
  if (is.na((orig_crs))) {

    message("No CRS set...using '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'...")
    sfin <- st_set_crs(sfin, st_crs("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
    orig_crs <- st_crs(sfin)

  }

  # convert it to Albers equal area
  sfin <- st_transform(sfin, st_crs("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

  ak_poly <- readRDS(system.file("extdata/alaska-sf-poly.rds", package="albersusa"))
  ak_bb <- readRDS(system.file("extdata/alaska_bb.rda", package="albersusa"))

  # saveRDS(ak_poly, "inst/extdata/alaska-sf-poly.rds", version = 2)
  # saveRDS(ak_bb, "inst/extdata/alaska_bb.rda", version = 2)

  hi_poly <- readRDS(system.file("extdata/hawaii-sf-poly.rds", package="albersusa"))
  hi_bb <- readRDS(system.file("extdata/hawaii_bb.rda", package="albersusa"))

  # saveRDS(hi_poly, "inst/extdata/hawaii-sf-poly.rds", version = 2)
  # saveRDS(hi_bb, "inst/extdata/hawaii_bb.rda", version = 2)

  ak_idx <- which(lengths(st_intersects(sfin, ak_poly)) != 0)
  hi_idx <- which(lengths(st_intersects(sfin, hi_poly)) != 0)

  tmp_ak <- sfin[ak_idx,]
  tmp_hi <- sfin[hi_idx,]

  rest <- c(ak_idx, hi_idx)

  if (length(rest) == 0) {
    tmp_in <- sfin
  } else {
    tmp_in <- sfin[-c(ak_idx, hi_idx),]
  }

  if (nrow(tmp_ak)) {
    tmp_ak <- as(tmp_ak, "Spatial")
    tmp_ak <- maptools::elide(tmp_ak, scale = max(apply(ak_bb, 1, diff)) / 2.3, rotate = -50, bb = ak_bb)
    tmp_ak <- maptools::elide(tmp_ak, shift = c(-1298669, -3018809))
    tmp_ak <- st_set_crs(as(tmp_ak, "sf"), st_crs("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
  } else {
    tmp_ak <- NULL
  }

  if (nrow(tmp_hi)) {
    tmp_hi <- as(tmp_hi, "Spatial")
    tmp_hi <- maptools::elide(tmp_hi, rotate = -35, bb = hi_bb)
    tmp_hi <- maptools::elide(tmp_hi, shift = c(5400000, -1400000))
    tmp_hi <- st_set_crs(as(tmp_hi, "sf"), st_crs("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
  } else {
    tmp_hi <- NULL
  }

  if (nrow(tmp_in) == 0) tmp_in <- NULL

  out <- rbind(tmp_ak, tmp_hi, tmp_in)

  out

}
