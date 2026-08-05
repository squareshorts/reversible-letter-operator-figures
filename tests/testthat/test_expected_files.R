test_that("data and figure files exist", {
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
