
`albersusa` : Tools, Shapefiles & Data to Work with an 'AlbersUSA' Composite Projection

The following functions are implemented:

- `usa_composite`:	Retreive a U.S. composite map, optionally with a projection
- `us_aeqd_proj`:	Oblique azimuthal equidistant convenience projection
- `us_eqdc_proj`:	Equidistant conic convenience projection
- `us_laea_proj`:	Albers equal-area conic convenience projection
- `us_lcc_proj`:	Lambert conformal conic convenience projection
- `us_longlat_proj`:	Generic long/lat convenience projection

The following data sets are included:

- `system.file("extdata/composite_us_states.geojson", package="albersusa")` - composite GeoJSON

### Installation


```r
devtools::install_github("hrbrmstr/albersusa")
```



### Usage


```r
library(albersusa)
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

```
## [1] '0.1.0'
```

```r
us <- usa_composite()

dplyr::glimpse(us@data)
```

```
## Observations: 51
## Variables: 11
## $ geo_id              (chr) "0400000US04", "0400000US05", "0400000US06", "0400000US08", "0400000US09", "0400000US11...
## $ fips_state          (chr) "04", "05", "06", "08", "09", "11", "13", "17", "18", "22", "27", "28", "30", "35", "38...
## $ name                (chr) "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "District of Columbia",...
## $ iso_3166_2          (chr) "AZ", "AR", "CA", "CO", "CT", "DC", "GA", "IL", "IN", "LA", "MN", "MS", "MT", "NM", "ND...
## $ census              (dbl) 6392017, 2915918, 37253956, 5029196, 3574097, 601723, 9687653, 12830632, 6483802, 45333...
## $ pop_estimataes_base (dbl) 6392310, 2915958, 37254503, 5029324, 3574096, 601767, 9688681, 12831587, 6484192, 45334...
## $ pop_2010            (dbl) 6411999, 2922297, 37336011, 5048575, 3579345, 605210, 9714464, 12840097, 6490308, 45455...
## $ pop_2011            (dbl) 6472867, 2938430, 37701901, 5119661, 3590537, 620427, 9813201, 12858725, 6516560, 45759...
## $ pop_2012            (dbl) 6556236, 2949300, 38062780, 5191709, 3594362, 635040, 9919000, 12873763, 6537632, 46047...
## $ pop_2013            (dbl) 6634997, 2958765, 38431393, 5272086, 3599341, 649111, 9994759, 12890552, 6570713, 46292...
## $ pop_2014            (dbl) 6731484, 2966369, 38802500, 5355866, 3596677, 658893, 10097343, 12880580, 6596855, 4649...
```

```r
plot(us)
```

<img src="README_files/figure-html/unnamed-chunk-3-1.png" title="" alt="" width="672" />

```r
us <- usa_composite("laea")
plot(us)
```

<img src="README_files/figure-html/unnamed-chunk-3-2.png" title="" alt="" width="672" />

```r
us <- usa_composite()
us_map <- fortify(us, region="name")

gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg <- gg + theme_map()

gg + coord_map()
```

<img src="README_files/figure-html/unnamed-chunk-3-3.png" title="" alt="" width="672" />

```r
gg + coord_map("polyconic")
```

<img src="README_files/figure-html/unnamed-chunk-3-4.png" title="" alt="" width="672" />

```r
gg + coord_proj()
```

<img src="README_files/figure-html/unnamed-chunk-3-5.png" title="" alt="" width="672" />

```r
gg + coord_proj(us_laea_proj)
```

<img src="README_files/figure-html/unnamed-chunk-3-6.png" title="" alt="" width="672" />

```r
gg + coord_proj(us_aeqd_proj)
```

<img src="README_files/figure-html/unnamed-chunk-3-7.png" title="" alt="" width="672" />

```r
gg + coord_proj(us_eqdc_proj)
```

<img src="README_files/figure-html/unnamed-chunk-3-8.png" title="" alt="" width="672" />

```r
gg + coord_proj(us_lcc_proj)
```

<img src="README_files/figure-html/unnamed-chunk-3-9.png" title="" alt="" width="672" />

```r
gg + 
  geom_map(data=us@data, map=us_map,
           aes(fill=pop_2014, map_id=name),
           color="white", size=0.1) +
  coord_proj(us_laea_proj) +
  scale_fill_viridis(name="2014 Populaton Estimates", labels=comma) +
  theme(legend.position="right")
```

<img src="README_files/figure-html/unnamed-chunk-3-10.png" title="" alt="" width="672" />

### Test Results


```r
library(albersusa)
library(testthat)

date()
```

```
## [1] "Mon Mar 28 22:38:24 2016"
```

```r
test_dir("tests/")
```

```
## testthat results ========================================================================================================
## OK: 0 SKIPPED: 0 FAILED: 0
```

