library(readr)
test_that("probabilities are between 0 and 1", {
  df2 <- read_csv("../../data/figure2_operator_probabilities.csv", show_col_types = FALSE)
  expect_true(all(df2$obs_prob >= 0 & df2$obs_prob <= 1, na.rm = TRUE))
  expect_true(all(df2$est_prob >= 0 & df2$est_prob <= 1, na.rm = TRUE))
})
