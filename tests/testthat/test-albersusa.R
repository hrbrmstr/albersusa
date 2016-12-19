context("Shapefile integrity")
test_that("we can do something", {

  us <- usa_composite()
  cty <- counties_composite()

  expect_that(us, is_a("SpatialPolygonsDataFrame"))
  expect_that(cty, is_a("SpatialPolygonsDataFrame"))

  expect_that(dim(us), equals(c(51, 13)))
  expect_that(dim(cty), equals(c(3143, 8)))

  expect_that(length(us@polygons), equals(51))
  expect_that(length(cty@polygons), equals(3143))

})
