#' Tools, Shapefiles & Data to Work with an 'AlbersUSA' Composite Projection
#'
#' Creating a composite projection for states and counties of the United States
#' that includes scaled and shifted polygons for Alaska and Hawaii is time consuming
#' and potentially error-prone. Functions and data sets are provided to make it easier to
#' produce maps with a composite projection. Furthermore, named projections for common
#' transormations are provided to further increase mapping productivity.
#'
#' Newer \code{sf} (simple features) objects can be returned or legacy R
#' spatial \code{sp} objects can be returned.
#'
#' Reference GeoJSON files are provided in the following locations (i.e. you can use
#' them in any mapping program):
#'
#' \preformatted{
#' system.file("extdata/composite_us_states.geojson.gz", package="albersusa")
#' system.file("extdata/composite_us_counties.geojson.gz", package="albersusa")
#' }
#'
#' @name albersusa
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import sp rgeos rgdal maptools
#' @import sf
NULL
