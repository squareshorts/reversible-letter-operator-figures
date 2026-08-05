library(readr)
library(dplyr)
test_that("primary values match constraints", {
  df1 <- read_csv("../../data/figureS1_rotation_benchmarks.csv", show_col_types = FALSE)
  obs_acc <- round(df1$observed_accuracy[1] * 100, 1)
  expect_equal(obs_acc, 34.5)
  
  df3 <- read_csv("../../data/figure3_primary_contrasts.csv", show_col_types = FALSE)
  check_val <- function(t, op, exp_est, exp_low, exp_up) {
    row <- df3 %>% filter(task == t & response_operator == op)
    est <- round(row$estimate * 100, 1)
    low <- round(row$boot_ci_lower * 100, 1)
    up <- round(row$boot_ci_upper * 100, 1)
    expect_true(abs(est - exp_est) <= 0.5)
    expect_true(abs(low - exp_low) <= 1.0)
    expect_true(abs(up - exp_up) <= 1.0)
  }
  check_val("rotation", "rotation_180", 16.9, 7.1, 26.7)
  check_val("rotation", "left_right_reflection", -28.0, -37.7, -18.7)
  check_val("rotation", "top_bottom_reflection", 11.1, 0.9, 21.5)
})
