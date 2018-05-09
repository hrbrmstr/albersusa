
[![Build
Status](https://travis-ci.org/hrbrmstr/albersusa.svg?branch=master)](https://travis-ci.org/hrbrmstr/albersusa)

# albersusa

Tools, Shapefiles & Data to Work with an ‘AlbersUSA’ Composite
Projection

## Description

## What’s Inside The Tin

The following functions are implemented:

  - `counties_sf`: Retreive a U.S. county composite map, optionally with
    a projection, as a simplefeature
  - `usa_sf`: Retreive a U.S. state composite map, optionally with a
    projection, as a simplefeature

New ones:

  - `points_elided`: Shift points around Alaska and Hawaii to the elided
    area (by @rdinter)

Some legacy ones:

  - `usa_composite`: Retreive a U.S. composite map, optionally with a
    projection
  - `counties_composite`: Retreive a U.S. county composite map,
    optionally with a projection

Pre-canned projection strings:

  - `us_aeqd_proj`: Oblique azimuthal equidistant convenience projection
  - `us_eqdc_proj`: Equidistant conic convenience projection
  - `us_laea_proj`: Albers equal-area conic convenience projection
  - `us_lcc_proj`: Lambert conformal conic convenience projection
  - `us_longlat_proj`: Generic long/lat convenience projection

The following data sets are included:

  - `system.file("extdata/composite_us_states.geojson.gz",
    package="albersusa")`
  - `system.file("extdata/composite_us_counties.geojson.gz",
    package="albersusa")`

Also, the simplefeatures coluns and `@data` slot of each
`SpatialPolygonsDataFrame` has some handy data you can use (like FIPS
codes and state/county population information).

## Installation

``` r
devtools::install_github("hrbrmstr/albersusa")
```

## Usage

``` r
library(albersusa)
library(sf)
library(sp)
library(rgeos)
library(maptools)
library(ggplot2)
library(ggalt)
library(ggthemes)
library(viridis)
library(scales)

# current verison
packageVersion("albersusa")
```

    ## [1] '0.3.0'

### Simple features

``` r
par(mar=c(0,0,1,0))

us_sf <- usa_sf("laea")
plot(us_sf["pop_2012"])
```

<img src="README_files/figure-gfm/unnamed-chunk-4-1.png" width="672" />

``` r
cty_sf <- counties_sf("aeqd")
plot(cty_sf["census_area"])
```

<img src="README_files/figure-gfm/unnamed-chunk-4-2.png" width="672" />

### Legacy

``` r
us <- usa_composite()

dplyr::glimpse(us@data)
```

    ## Observations: 51
    ## Variables: 13
    ## $ geo_id              <chr> "0400000US04", "0400000US05", "0400000US06", "0400000US08", "0400000US09", "0400000US11...
    ## $ fips_state          <chr> "04", "05", "06", "08", "09", "11", "13", "17", "18", "22", "27", "28", "30", "35", "38...
    ## $ name                <chr> "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "District of Columbia",...
    ## $ lsad                <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",...
    ## $ census_area         <dbl> 113594.084, 52035.477, 155779.220, 103641.888, 4842.355, 61.048, 57513.485, 55518.930, ...
    ## $ iso_3166_2          <chr> "AZ", "AR", "CA", "CO", "CT", "DC", "GA", "IL", "IN", "LA", "MN", "MS", "MT", "NM", "ND...
    ## $ census              <int> 6392017, 2915918, 37253956, 5029196, 3574097, 601723, 9687653, 12830632, 6483802, 45333...
    ## $ pop_estimataes_base <int> 6392310, 2915958, 37254503, 5029324, 3574096, 601767, 9688681, 12831587, 6484192, 45334...
    ## $ pop_2010            <int> 6411999, 2922297, 37336011, 5048575, 3579345, 605210, 9714464, 12840097, 6490308, 45455...
    ## $ pop_2011            <int> 6472867, 2938430, 37701901, 5119661, 3590537, 620427, 9813201, 12858725, 6516560, 45759...
    ## $ pop_2012            <int> 6556236, 2949300, 38062780, 5191709, 3594362, 635040, 9919000, 12873763, 6537632, 46047...
    ## $ pop_2013            <int> 6634997, 2958765, 38431393, 5272086, 3599341, 649111, 9994759, 12890552, 6570713, 46292...
    ## $ pop_2014            <int> 6731484, 2966369, 38802500, 5355866, 3596677, 658893, 10097343, 12880580, 6596855, 4649...

``` r
plot(us, lwd=0.25)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-1.png" width="672" />

``` r
us <- usa_composite("laea")
plot(us, lwd=0.25)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-2.png" width="672" />

``` r
us <- usa_composite()
us_map <- fortify(us, region="name")

gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg <- gg + theme_map()

gg + coord_map()
```

<img src="README_files/figure-gfm/unnamed-chunk-5-3.png" width="672" />

``` r
gg + coord_map("polyconic")
```

<img src="README_files/figure-gfm/unnamed-chunk-5-4.png" width="672" />

``` r
gg + coord_proj()
```

<img src="README_files/figure-gfm/unnamed-chunk-5-5.png" width="672" />

``` r
gg + coord_proj(us_laea_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-6.png" width="672" />

``` r
gg + coord_proj(us_aeqd_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-7.png" width="672" />

``` r
gg + coord_proj(us_eqdc_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-8.png" width="672" />

``` r
gg + coord_proj(us_lcc_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-9.png" width="672" />

``` r
gg + 
  geom_map(data=us@data, map=us_map,
           aes(fill=pop_2014, map_id=name),
           color="white", size=0.1) +
  coord_proj(us_laea_proj) +
  scale_fill_viridis(name="2014 Populaton Estimates", labels=comma) +
  theme(legend.position="top", 
        legend.key.width=unit(3, "lines"))
```

<img src="README_files/figure-gfm/unnamed-chunk-5-10.png" width="672" />

``` r
us <- counties_composite()

dplyr::glimpse(us@data)
```

    ## Observations: 3,143
    ## Variables: 8
    ## $ fips        <chr> "01001", "01009", "01017", "01021", "01033", "01045", "01051", "01065", "01079", "01083", "0109...
    ## $ state_fips  <chr> "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "05", "05", "06",...
    ## $ county_fips <chr> "001", "009", "017", "021", "033", "045", "051", "065", "079", "083", "099", "107", "121", "141...
    ## $ name        <chr> "Autauga", "Blount", "Chambers", "Chilton", "Colbert", "Dale", "Elmore", "Hale", "Lawrence", "L...
    ## $ lsad        <chr> "County", "County", "County", "County", "County", "County", "County", "County", "County", "Coun...
    ## $ census_area <dbl> 594.436, 644.776, 596.531, 692.854, 592.619, 561.150, 618.485, 643.943, 690.678, 559.936, 1025....
    ## $ state       <chr> "Alabama", "Alabama", "Alabama", "Alabama", "Alabama", "Alabama", "Alabama", "Alabama", "Alabam...
    ## $ iso_3166_2  <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AR", "AR", "CA",...

``` r
plot(us, lwd=0.25)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-11.png" width="672" />

``` r
us <- counties_composite("laea")
plot(us, lwd=0.25)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-12.png" width="672" />

``` r
us <- counties_composite()
us_map <- fortify(us, region="fips")

gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg <- gg + theme_map()

gg + coord_map()
```

<img src="README_files/figure-gfm/unnamed-chunk-5-13.png" width="672" />

``` r
gg + coord_map("polyconic")
```

<img src="README_files/figure-gfm/unnamed-chunk-5-14.png" width="672" />

``` r
gg + coord_proj()
```

<img src="README_files/figure-gfm/unnamed-chunk-5-15.png" width="672" />

``` r
gg + coord_proj(us_laea_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-16.png" width="672" />

``` r
gg + coord_proj(us_aeqd_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-17.png" width="672" />

``` r
gg + coord_proj(us_eqdc_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-18.png" width="672" />

``` r
gg + coord_proj(us_lcc_proj)
```

<img src="README_files/figure-gfm/unnamed-chunk-5-19.png" width="672" />

### Session Info

``` r
devtools::session_info()
```

    ## Session info ----------------------------------------------------------------------------------------------------------

    ##  setting  value                                 
    ##  version  R version 3.5.0 RC (2018-04-15 r74605)
    ##  system   x86_64, darwin15.6.0                  
    ##  ui       X11                                   
    ##  language (EN)                                  
    ##  collate  en_US.UTF-8                           
    ##  tz       America/New_York                      
    ##  date     2018-05-09

    ## Packages --------------------------------------------------------------------------------------------------------------

    ##  package      * version    date       source                            
    ##  albersusa    * 0.3.0      2018-05-09 local                             
    ##  ash            1.0-15     2015-09-01 cran (@1.0-15)                    
    ##  assertthat     0.2.0      2017-04-11 CRAN (R 3.5.0)                    
    ##  backports      1.1.2      2017-12-13 CRAN (R 3.5.0)                    
    ##  base         * 3.5.0      2018-04-16 local                             
    ##  bindr          0.1.1      2018-03-13 CRAN (R 3.5.0)                    
    ##  bindrcpp       0.2.2      2018-03-29 CRAN (R 3.5.0)                    
    ##  class          7.3-14     2015-08-30 CRAN (R 3.5.0)                    
    ##  classInt       0.2-3      2018-04-16 CRAN (R 3.5.0)                    
    ##  colorspace     1.3-2      2016-12-14 CRAN (R 3.5.0)                    
    ##  compiler       3.5.0      2018-04-16 local                             
    ##  datasets     * 3.5.0      2018-04-16 local                             
    ##  DBI            0.8        2018-03-02 CRAN (R 3.5.0)                    
    ##  devtools       1.13.5     2018-02-18 CRAN (R 3.5.0)                    
    ##  digest         0.6.15     2018-01-28 CRAN (R 3.5.0)                    
    ##  dplyr          0.7.4      2017-09-28 CRAN (R 3.5.0)                    
    ##  e1071          1.6-8      2017-02-02 cran (@1.6-8)                     
    ##  evaluate       0.10.1     2017-06-24 CRAN (R 3.5.0)                    
    ##  extrafont      0.17       2014-12-08 cran (@0.17)                      
    ##  extrafontdb    1.0        2012-06-11 cran (@1.0)                       
    ##  foreign        0.8-70     2017-11-28 CRAN (R 3.5.0)                    
    ##  ggalt        * 0.6.0      2018-04-17 Github (hrbrmstr/ggalt@9ad95ba)   
    ##  ggplot2      * 2.2.1.9000 2018-05-03 Github (tidyverse/ggplot2@6a261a2)
    ##  ggthemes     * 3.4.2      2018-04-03 CRAN (R 3.5.0)                    
    ##  glue           1.2.0      2017-10-29 CRAN (R 3.5.0)                    
    ##  graphics     * 3.5.0      2018-04-16 local                             
    ##  grDevices    * 3.5.0      2018-04-16 local                             
    ##  grid           3.5.0      2018-04-16 local                             
    ##  gridExtra      2.3        2017-09-09 CRAN (R 3.5.0)                    
    ##  gtable         0.2.0      2016-02-26 CRAN (R 3.5.0)                    
    ##  htmltools      0.3.6      2017-04-28 CRAN (R 3.5.0)                    
    ##  KernSmooth     2.23-15    2015-06-29 CRAN (R 3.5.0)                    
    ##  knitr          1.20       2018-02-20 CRAN (R 3.5.0)                    
    ##  labeling       0.3        2014-08-23 CRAN (R 3.5.0)                    
    ##  lattice        0.20-35    2017-03-25 CRAN (R 3.5.0)                    
    ##  lazyeval       0.2.1      2017-10-29 CRAN (R 3.5.0)                    
    ##  magrittr       1.5        2014-11-22 CRAN (R 3.5.0)                    
    ##  mapproj        1.2.6      2018-03-29 CRAN (R 3.5.0)                    
    ##  maps           3.3.0      2018-04-03 cran (@3.3.0)                     
    ##  maptools     * 0.9-2      2017-03-25 CRAN (R 3.5.0)                    
    ##  MASS           7.3-50     2018-04-30 CRAN (R 3.5.0)                    
    ##  memoise        1.1.0      2017-04-21 CRAN (R 3.5.0)                    
    ##  methods      * 3.5.0      2018-04-16 local                             
    ##  munsell        0.4.3      2016-02-13 CRAN (R 3.5.0)                    
    ##  pillar         1.2.2      2018-04-26 CRAN (R 3.5.0)                    
    ##  pkgconfig      2.0.1      2017-03-21 CRAN (R 3.5.0)                    
    ##  plyr           1.8.4      2016-06-08 CRAN (R 3.5.0)                    
    ##  proj4          1.0-8      2012-08-05 cran (@1.0-8)                     
    ##  R6             2.2.2      2017-06-17 CRAN (R 3.5.0)                    
    ##  RColorBrewer   1.1-2      2014-12-07 CRAN (R 3.5.0)                    
    ##  Rcpp           0.12.16    2018-03-13 CRAN (R 3.5.0)                    
    ##  rgdal          1.2-18     2018-03-17 CRAN (R 3.5.0)                    
    ##  rgeos        * 0.3-26     2017-10-31 CRAN (R 3.5.0)                    
    ##  rlang          0.2.0.9001 2018-05-03 Github (r-lib/rlang@4803704)      
    ##  rmarkdown      1.9        2018-03-01 CRAN (R 3.5.0)                    
    ##  RPostgreSQL    0.6-2      2017-06-24 CRAN (R 3.5.0)                    
    ##  rprojroot      1.3-2      2018-01-03 CRAN (R 3.5.0)                    
    ##  Rttf2pt1       1.3.6      2018-02-22 cran (@1.3.6)                     
    ##  scales       * 0.5.0.9000 2018-05-04 Github (hadley/scales@d767915)    
    ##  sf           * 0.6-2      2018-04-25 CRAN (R 3.5.0)                    
    ##  sp           * 1.2-7      2018-01-19 CRAN (R 3.5.0)                    
    ##  spData         0.2.8.3    2018-03-25 CRAN (R 3.5.0)                    
    ##  stats        * 3.5.0      2018-04-16 local                             
    ##  stringi        1.2.2      2018-05-02 cran (@1.2.2)                     
    ##  stringr        1.3.0      2018-02-19 CRAN (R 3.5.0)                    
    ##  tibble         1.4.2      2018-01-22 CRAN (R 3.5.0)                    
    ##  tools          3.5.0      2018-04-16 local                             
    ##  udunits2       0.13       2016-11-17 cran (@0.13)                      
    ##  units          0.5-1      2018-01-08 cran (@0.5-1)                     
    ##  utils        * 3.5.0      2018-04-16 local                             
    ##  viridis      * 0.5.1      2018-03-29 CRAN (R 3.5.0)                    
    ##  viridisLite  * 0.3.0      2018-02-01 CRAN (R 3.5.0)                    
    ##  withr          2.1.2      2018-05-03 Github (jimhester/withr@79d7b0d)  
    ##  yaml           2.1.19     2018-05-01 CRAN (R 3.5.0)

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
