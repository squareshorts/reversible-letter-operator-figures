options(stringsAsFactors = FALSE)
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(tidyr))

in_dir <- "C:/work/letter_operator_reanalysis"
out_dir <- "C:/work/reversible_letter_operator_figures/data"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# Helper for school names
anonymize_schools <- function(x) {
  # Fix encoding issues and anonymize
  x <- gsub("Andr.* Avelino", "School A", x, ignore.case=TRUE)
  x <- gsub("Virg.*lio", "School B", x, ignore.case=TRUE)
  x <- gsub("andre_avelino", "school_a", x, ignore.case=TRUE)
  x <- gsub("virgilio", "school_b", x, ignore.case=TRUE)
  return(x)
}

# 1. Figure 2
cat("Building Figure 2 data...\n")
df2 <- read_csv(file.path(in_dir, "tables_revision/operator_probabilities_by_grade.csv"), show_col_types = FALSE)
df2_clean <- df2 %>% select(task, grade, response_operator, obs_prob, est_prob)
write_csv(df2_clean, file.path(out_dir, "figure2_operator_probabilities.csv"))

# 2. Figure 3
cat("Building Figure 3 data...\n")
df3_authoritative <- read_csv(file.path(in_dir, "analysis_remaining_robustness/01_reproduction/operator_contrasts_reproduced.csv"), show_col_types = FALSE)
df3_clean <- df3_authoritative %>% 
  mutate(
    estimate = difference_pp / 100,
    boot_ci_lower = ci_low_pp / 100,
    boot_ci_upper = ci_high_pp / 100
  ) %>%
  select(task, response_operator = operator, estimate, boot_ci_lower, boot_ci_upper)
write_csv(df3_clean, file.path(out_dir, "figure3_primary_contrasts.csv"))

# 3. Figure 4
cat("Building Figure 4 data...\n")
df4 <- read_csv(file.path(in_dir, "analysis_remaining_robustness/07_integrated_robustness/principal_rotation_robustness.csv"), show_col_types = FALSE)
df4_clean <- df4 %>% filter(!is.na(ci_low_pp)) %>%
  select(analysis_family, model_specification, estimand, operator, estimate_pp, ci_low_pp, ci_high_pp) %>%
  mutate(
    model_specification = anonymize_schools(model_specification),
    estimand = anonymize_schools(estimand)
  )
write_csv(df4_clean, file.path(out_dir, "figure4_robustness_contrasts.csv"))

# 4. Figure S1
cat("Building Figure S1 data...\n")
dfs1 <- read_csv(file.path(in_dir, "tables_revision/position_bias_benchmarks.csv"), show_col_types = FALSE)
dfs1_clean <- dfs1 %>% select(benchmark_name, expected_accuracy, observed_accuracy)
write_csv(dfs1_clean, file.path(out_dir, "figureS1_rotation_benchmarks.csv"))

# 5. Figure S2
cat("Building Figure S2 data...\n")
dfs2 <- read_csv(file.path(in_dir, "tables_revision/model_comparisons_revision.csv"), show_col_types = FALSE)
dfs2_clean <- dfs2 %>% select(task, model_type, aic)
write_csv(dfs2_clean, file.path(out_dir, "figureS2_aic_comparison.csv"))

# 6. Figure S3
cat("Building Figure S3 data...\n")
dfs3_est <- read_csv(file.path(in_dir, "tables_revision/school_stratified_contrasts.csv"), show_col_types = FALSE)
dfs3_boot <- read_csv(file.path(in_dir, "tables_v3/cluster_bootstrap_summary_v3.csv"), show_col_types = FALSE)

# we need to combine the point estimates and bootstrap CIs.
dfs3_boot_clean <- dfs3_boot %>% 
  mutate(school_sample = case_when(
    grepl("Avelino", analysis, ignore.case=TRUE) ~ "school_a_est",
    grepl("Virg", analysis, ignore.case=TRUE) ~ "school_b_est",
    analysis == "pooled" ~ "pooled_adjusted_est",
    TRUE ~ "unknown"
  )) %>%
  select(task, response_operator = category, school_sample, ci_lower, ci_upper)

dfs3_est_clean <- dfs3_est %>% 
  select(task, response_operator, pooled_adjusted_est, school_a_est = andre_avelino_est, school_b_est = virgilio_est) %>%
  pivot_longer(cols = c(pooled_adjusted_est, school_a_est, school_b_est), names_to = "school_sample", values_to = "estimate")

dfs3_final <- dfs3_est_clean %>%
  left_join(dfs3_boot_clean, by = c("task", "response_operator", "school_sample")) %>%
  mutate(school_sample = case_when(
    school_sample == "school_a_est" ~ "School A",
    school_sample == "school_b_est" ~ "School B",
    school_sample == "pooled_adjusted_est" ~ "Pooled Adjusted"
  )) %>%
  select(task, response_operator, school_sample, estimate, ci_lower, ci_upper)

write_csv(dfs3_final, file.path(out_dir, "figureS3_school_contrasts.csv"))

cat("All public data built successfully.\n")
