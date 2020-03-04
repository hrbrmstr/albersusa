#' Retrieve a U.S. state composite map, optionally with a projection
#'
#' The \code{proj} parameter is intende to simplify usage for those using base
#' plotting. If anything but \code{longlat} is specified the composite map
#' will be pre-projected to those
#'
#' This is what's in the SPDF \code{@data} slot:
#'
#' \preformatted{
#' Observations: 51
#' Variables: 13
#' $ geo_id              (chr) "0400000US04", "0400000US05", "0400000US06", "0400...
#' $ fips_state          (chr) "04", "05", "06", "08", "09", "11", "13", "17", "1...
#' $ name                (chr) "Arizona", "Arkansas", "California", "Colorado", "...
#' $ iso_3166_2          (chr) "AZ", "AR", "CA", "CO", "CT", "DC", "GA", "IL", "I...
#' $ census              (int) 6392017, 2915918, 37253956, 5029196, 3574097, 6017...
#' $ pop_estimataes_base (int) 6392310, 2915958, 37254503, 5029324, 3574096, 6017...
#' $ pop_2010            (int) 6411999, 2922297, 37336011, 5048575, 3579345, 6052...
#' $ pop_2011            (int) 6472867, 2938430, 37701901, 5119661, 3590537, 6204...
#' $ pop_2012            (int) 6556236, 2949300, 38062780, 5191709, 3594362, 6350...
#' $ pop_2013            (int) 6634997, 2958765, 38431393, 5272086, 3599341, 6491...
#' $ pop_2014            (int) 6731484, 2966369, 38802500, 5355866, 3596677, 6588...
#' }
#'
#' A reference GeoJSON file is provided in the following location (i.e. you can use
#' it in any mapping program):
#'
#' \preformatted{
#' system.file("extdata/composite_us_states.geojson.gz", package="albersusa")
#' }
#'
#' @param proj if anything but \code{longlat} is specified, the shapefile will
#'        be pre-projected before being returned
#' @export
#' @examples
#' library(sp)
#'
#' plot(usa_composite())
#' plot(usa_composite("laea"))
usa_composite <- function(proj=c("longlat", "laea", "lcc", "eqdc", "aeqd")) {

  # us <- readOGR(system.file("extdata/composite_us_states.geojson", package="albersusa"),
  #               "OGRGeoJSON",
  #               stringsAsFactors=FALSE,
  #               verbose=FALSE)

  us <- readRDS(system.file("extdata/states.rda", package="albersusa"))
  # saveRDS(us, "inst/extdata/states.rda", version = 2)

  proj <- match.arg(proj, c("longlat", "laea", "lcc", "eqdc", "aeqd"))

  if (proj != "longlat") {

    proj <- switch(proj,
                   laea=us_laea_proj,
                   lcc=us_lcc_proj,
                   eqdc=us_eqdc_proj,
                   aeqd=us_aeqd_proj)

    us <- sp::spTransform(us, sp::CRS(proj))

  }

  us

}