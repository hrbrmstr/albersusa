#' Retreive a U.S. county composite map, optionally with a projection
#'
#' The \code{proj} parameter is intende to simplify usage for those using base
#' plotting. If anything but \code{longlat} is specified the composite map
#' will be pre-projected to those
#'
#' This is what's in the SPDF \code{@data} slot:
#'
#' \preformatted{
#' Observations: 3,143
#' Variables: 8
#' $ fips        (chr) "01001", "01009", "01017", "01021", "01033", "010...
#' $ state_fips  (chr) "01", "01", "01", "01", "01", "01", "01", "01", "...
#' $ county_fips (chr) "001", "009", "017", "021", "033", "045", "051", ...
#' $ name        (chr) "Autauga", "Blount", "Chambers", "Chilton", "Colb...
#' $ lsad        (chr) "County", "County", "County", "County", "County",...
#' $ census_area (dbl) 594.436, 644.776, 596.531, 692.854, 592.619, 561....
#' #' $ state       (chr) "Alabama", "Alabama", "Alabama", "Alabama", "Alab...
#' $ iso_3166_2  (chr) "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "...
#' }
#'
#' @param proj if anything but \code{longlat} is specified, the shapefile will
#'        be pre-projected before being returned
#' @export
#' @examples
#' plot(counties_composite())
#'
#' plot(counties_composite("laea"))
counties_composite <- function(proj=c("longlat", "laea", "lcc", "eqdc", "aeqd")) {

  # us <- readOGR(system.file("extdata/counties_composite.geojson", package="albersusa"),
  #               "OGRGeoJSON",
  #               stringsAsFactors=FALSE,
  #               verbose=FALSE)

  cty <- readRDS(system.file("extdata/counties.rda", package="albersusa"))

  proj <- match.arg(proj, c("longlat", "laea", "lcc", "eqdc", "aeqd"))

  if (proj != "longlat") {

    proj <- switch(proj,
                   laea=us_laea_proj,
                   lcc=us_lcc_proj,
                   eqdc=us_eqdc_proj,
                   aeqd=us_aeqd_proj)

    cty <- sp::spTransform(cty, sp::CRS(proj))

  }

  cty

}