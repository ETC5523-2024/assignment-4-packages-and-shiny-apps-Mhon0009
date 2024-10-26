test_that("historical_full_spending dataset loads correctly", {
  expect_true(exists("historical_full_spending"))
  expect_s3_class(historical_full_spending, "data.frame")
  expect_equal(ncol(historical_full_spending), 11)  # 11 columns expected
  expect_equal(nrow(historical_full_spending),13)  # 13 rows expected
})
