test_that("gifts_gender dataset loads correctly", {
  expect_true(exists("gifts_gender"))
  expect_s3_class(gifts_gender, "data.frame")
  expect_equal(ncol(gifts_gender), 9)  # 9 columns expected
  expect_equal(nrow(gifts_gender), 2)  # 2 rows expected
})

