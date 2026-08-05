options(stringsAsFactors = FALSE)
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})

cat("Validating inputs...\n")

# 1. Check Rotation accuracy
df1 <- read_csv("data/figureS1_rotation_benchmarks.csv", show_col_types = FALSE)
obs_acc <- round(df1$observed_accuracy[1] * 100, 1)
if (obs_acc != 34.5) stop("Validation failed: Rotation accuracy must be 34.5%. Found: ", obs_acc)

# 2. Check Contrast bounds
df3 <- read_csv("data/figure3_primary_contrasts.csv", show_col_types = FALSE)

check_val <- function(t, op, exp_est, exp_low, exp_up) {
  row <- df3 %>% filter(task == t & response_operator == op)
  if (nrow(row) == 0) stop(paste("Missing data for", op))
  
  est <- round(row$estimate * 100, 1)
  low <- round(row$boot_ci_lower * 100, 1)
  up <- round(row$boot_ci_upper * 100, 1)
  
  if (abs(est - exp_est) > 0.5) stop(paste("Validation failed: est wrong for", op, "found", est, "expected", exp_est))
  if (abs(low - exp_low) > 1.0) stop(paste("Validation failed: low wrong for", op, "found", low, "expected", exp_low))
  if (abs(up - exp_up) > 1.0) stop(paste("Validation failed: up wrong for", op, "found", up, "expected", exp_up))
}

check_val("rotation", "rotation_180", 16.9, 7.1, 26.7)
check_val("rotation", "left_right_reflection", -28.0, -37.7, -18.7)
check_val("rotation", "top_bottom_reflection", 11.1, 0.9, 21.5)

# 3. Ensure no absolute paths (checking basic script text)
scripts <- list.files("scripts", pattern = "\\.R$", full.names = TRUE)
for (s in scripts) {
  content <- readLines(s, warn = FALSE)
  # Check for C:/ or C:\\ paths but avoid self-triggering
  if (any(grepl("C:/|C:\\\\", content, ignore.case = TRUE))) {
    if (!grepl("build_public_data.R|validate_inputs.R", s)) {
      stop(paste("Validation failed: Absolute path found in", s))
    }
  }
}

cat("Input validation passed!\n")
