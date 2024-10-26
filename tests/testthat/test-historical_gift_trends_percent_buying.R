test_that("historical_gift_trends_percent_buying dataset loads correctly", {
  expect_true(exists("historical_gift_trends_percent_buying"))
  expect_s3_class(historical_gift_trends_percent_buying, "data.frame")
  expect_equal(ncol(historical_gift_trends_percent_buying), 8)  # 8 columns expected
  expect_equal(nrow(historical_gift_trends_percent_buying),13)  # 13 rows expected
})
