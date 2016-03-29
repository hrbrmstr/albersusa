#' Albers equal-area conic convenience projection
#'
#' The following PROJ.4 string is used: \code{+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs}
#'
#' In a ggplot2+ggalt context, you can just use variable name as the value for the \code{proj}
#' parameter to \code{ggalt::coord_proj()}. i.e. \code{coord_proj(us_laea_proj)}.
#'
#' @family convenience projections
#' @export
#' @examples
#' us <- usa_composite()
#' us <- sp::spTransform(us, sp::CRS(us_laea_proj))
#' us <- usa_composite(proj="laea")
#' counties <- counties_composite("laea")
us_laea_proj <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"


#' Generic long/lat convenience projection
#'
#' The following PROJ.4 string is used: \code{+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0}
#'
#' In a ggplot2+ggalt context, you can just use variable name as the value for the \code{proj}
#' parameter to \code{ggalt::coord_proj()}. i.e. \code{coord_proj(us_longlat_proj)}.
#'
#' @export
#' @examples
#' us <- usa_composite() # it's the default
#' us <- sp::spTransform(us, sp::CRS(us_longlat_proj))
#' counties <- counties_composite()
us_longlat_proj <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


#' Lambert conformal conic convenience projection
#'
#' The following PROJ.4 string is used: \code{+proj=lcc +lat_1=27.11637320883929 +lat_2=53.050729042644335 +lon_0=-95.44921875}
#'
#' In a ggplot2+ggalt context, you can just use variable name as the value for the \code{proj}
#' parameter to \code{ggalt::coord_proj()}. i.e. \code{coord_proj(us_lcc_proj)}.
#'
#' @family convenience projections
#' @export
#' @examples
#' us <- usa_composite()
#' us <- sp::spTransform(us, sp::CRS(us_lcc_proj))
#' us <- usa_composite(proj="lcc")
#' counties <- counties_composite("lcc")
us_lcc_proj <- "+proj=lcc +lat_1=27.11637320883929 +lat_2=53.050729042644335 +lon_0=-95.44921875"


#' Equidistant conic convenience projection
#'
#' Distance correct along meridians
#'
#' The following PROJ.4 string is used: \code{+proj=eqdc +lat_1=27.11637320883929 +lat_2=53.050729042644335 +lon_0=-95.44921875}
#'
#' In a ggplot2+ggalt context, you can just use variable name as the value for the \code{proj}
#' parameter to \code{ggalt::coord_proj()}. i.e. \code{coord_proj(us_eqdc_proj)}.
#'
#' @family convenience projections
#' @export
#' @examples
#' us <- usa_composite()
#' us <- sp::spTransform(us, sp::CRS(us_eqdc_proj))
#' us <- usa_composite(proj="eqdc")
#' counties <- counties_composite("eqdc")
#'
us_eqdc_proj <- "+proj=eqdc +lat_1=27.11637320883929 +lat_2=53.050729042644335 +lon_0=-95.44921875"


#' Oblique azimuthal equidistant convenience projection
#'
#' Distance correct along any line passing through the center of the map (i.e., great circle)
#'
#' The following PROJ.4 string is used: \code{+proj=aeqd +lat_0=40.08355112574181 +lon_0=-95.44921875}
#'
#' In a ggplot2+ggalt context, you can just use variable name as the value for the \code{proj}
#' parameter to \code{ggalt::coord_proj()}. i.e. \code{coord_proj(us_aeqd_proj)}.
#'
#' @family convenience projections
#' @export
#' @examples
#' us <- usa_composite()
#' us <- sp::spTransform(us, sp::CRS(us_aeqd_proj))
#' us <- usa_composite(proj="aeqd")
#' counties <- counties_composite("aeqd")
us_aeqd_proj <- "+proj=aeqd +lat_0=40.08355112574181 +lon_0=-95.44921875"

