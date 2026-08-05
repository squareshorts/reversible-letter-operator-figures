import os

testthat_dir = "C:/work/reversible_letter_operator_figures/tests/testthat"
os.makedirs(testthat_dir, exist_ok=True)

f1 = """test_that("data and figure files exist", {
  expected_data <- c("figure2_operator_probabilities.csv", "figure3_primary_contrasts.csv", 
                     "figure4_robustness_contrasts.csv", "figureS1_rotation_benchmarks.csv",
                     "figureS2_aic_comparison.csv", "figureS3_school_contrasts.csv")
  for (f in expected_data) {
    expect_true(file.exists(file.path("../../data", f)))
  }
  
  expected_figures <- c("Figure_2.pdf", "Figure_3.pdf", "Figure_4.pdf", "Figure_S1.pdf", "Figure_S2.pdf", "Figure_S3.pdf")
  for (f in expected_figures) {
    expect_true(file.exists(file.path("../../figures", f)))
  }
})
"""

f2 = """library(readr)
test_that("probabilities are between 0 and 1", {
  df2 <- read_csv("../../data/figure2_operator_probabilities.csv", show_col_types = FALSE)
  expect_true(all(df2$obs_prob >= 0 & df2$obs_prob <= 1, na.rm = TRUE))
  expect_true(all(df2$est_prob >= 0 & df2$est_prob <= 1, na.rm = TRUE))
})
"""

f3 = """library(readr)
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
"""

f4 = """test_that("no unapproved school names in data", {
  files <- list.files("../../data", full.names = TRUE, pattern = "\\\\.csv$")
  for (f in files) {
    content <- readLines(f, warn = FALSE)
    expect_false(any(grepl("avelino", content, ignore.case = TRUE)))
    expect_false(any(grepl("virgilio", content, ignore.case = TRUE)))
    expect_false(any(grepl("andr", content, ignore.case = TRUE)))
  }
})
"""

with open(os.path.join(testthat_dir, "test_expected_files.R"), "w", encoding="utf-8") as f: f.write(f1)
with open(os.path.join(testthat_dir, "test_probability_constraints.R"), "w", encoding="utf-8") as f: f.write(f2)
with open(os.path.join(testthat_dir, "test_primary_values.R"), "w", encoding="utf-8") as f: f.write(f3)
with open(os.path.join(testthat_dir, "test_privacy_terms.R"), "w", encoding="utf-8") as f: f.write(f4)

print("Tests written.")
