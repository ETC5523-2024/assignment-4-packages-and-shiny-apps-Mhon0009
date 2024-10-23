
test_that("gifts_age dataset loads correctly", {
  expect_true(exists("gifts_age"))
  expect_s3_class(gifts_age, "data.frame")
  expect_equal(ncol(gifts_age), 9)  # 9 columns expected
  expect_equal(nrow(gifts_age), 6)  # 6 rows expected
})

