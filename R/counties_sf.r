#' Retrieve a U.S. county composite map, optionally with a projection, as a simplefeature
#'
#' The \code{proj} parameter is intende to simplify usage for those using base
#' plotting. If anything but \code{longlat} is specified the composite map
#' will be pre-projected to those
#'
#' This is what's in the object looks like:
#'
#' \preformatted{
#' Observations: 3,143
#' Variables: 9
#' $ fips        <fctr> 01001, 01009, 01017, 01021, 01033, 01045, 01051, 01065, 01079, 0...
#' $ state_fips  <fctr> 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 05, 05, 06, ...
#' $ county_fips <fctr> 001, 009, 017, 021, 033, 045, 051, 065, 079, 083, 099, 107, 121,...
#' $ name        <fctr> Autauga, Blount, Chambers, Chilton, Colbert, Dale, Elmore, Hale,...
#' $ lsad        <fctr> County, County, County, County, County, County, County, County, ...
#' $ census_area <dbl> 594.436, 644.776, 596.531, 692.854, 592.619, 561.150, 618.485, 64...
#' $ state       <fctr> Alabama, Alabama, Alabama, Alabama, Alabama, Alabama, Alabama, A...
#' $ iso_3166_2  <fctr> AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AR, AR, CA, ...
#' $ geometry    <simple_feature> MULTIPOLYGON(((-86.496774 3..., MULTIPOLYGON(((-86.577...#' }
#'
#' A reference GeoJSON file isprovided in the following location (i.e. you can use
#' it in any mapping program):
#'
#' \preformatted{
#' system.file("extdata/composite_us_counties.geojson.gz", package="albersusa")
#' }
#'
#' @param proj if anything but \code{longlat} is specified, the shapefile will
#'        be pre-projected before being returned
#' @export
#' @examples
#' library(sf)
#'
#' plot(counties_sf()) # these take a while to render
#' plot(counties_sf("laea"))
counties_sf <- function(proj=c("longlat", "laea", "lcc", "eqdc", "aeqd")) {

  # us <- readOGR(system.file("extdata/composite_us_counties.geojson", package="albersusa"),
  #               "OGRGeoJSON",
  #               stringsAsFactors=FALSE,
  #               verbose=FALSE)

  cty <- readRDS(system.file("extdata/counties_sf.rda", package="albersusa"))
  # saveRDS(cty, "inst/extdata/counties_sf.rda", version = 2)

  proj <- match.arg(proj, c("longlat", "laea", "lcc", "eqdc", "aeqd"))

  if (proj != "longlat") {

    proj <- switch(proj,
                   laea=us_laea_proj,
                   lcc=us_lcc_proj,
                   eqdc=us_eqdc_proj,
                   aeqd=us_aeqd_proj)

    cty <- sf::st_transform(cty, proj)

  }

  cty

}
