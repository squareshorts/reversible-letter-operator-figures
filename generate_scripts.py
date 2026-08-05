import os

scripts_dir = "C:/work/reversible_letter_operator_figures/scripts"
os.makedirs(scripts_dir, exist_ok=True)

common_header = """options(stringsAsFactors = FALSE, warn = 1)
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
})

theme_set(theme_bw(base_size = 11) + theme(
  panel.grid.minor = element_blank(),
  strip.background = element_rect(fill = "gray92", color = NA),
  strip.text = element_text(face = "bold", size = 10),
  legend.position = "bottom"
))
"""

fig2_code = common_header + """
cat("Generating Figure 2...\n")
df <- read_csv("data/figure2_operator_probabilities.csv", show_col_types = FALSE)

df <- df %>% mutate(
  task_label = case_when(
    task == "lowercase_identification" ~ "Lowercase Identification",
    task == "mirror" ~ "Mirror Task",
    task == "rotation" ~ "Rotation Task"
  ),
  operator_label = case_when(
    response_operator == "identity" ~ "Identity",
    response_operator == "left_right_reflection" ~ "Left-Right Reflection",
    response_operator == "top_bottom_reflection" ~ "Top-Bottom Reflection",
    response_operator == "rotation_180" ~ "180° Rotation"
  )
)

df <- df %>% mutate(
  is_correct = case_when(
    task == "rotation" & response_operator == "rotation_180" ~ TRUE,
    task == "mirror" & response_operator %in% c("left_right_reflection", "top_bottom_reflection") ~ TRUE,
    task == "lowercase_identification" & response_operator == "identity" ~ TRUE,
    TRUE ~ FALSE
  ),
  operator_label = ifelse(is_correct, paste0(operator_label, " *"), operator_label)
)

p2 <- ggplot(df, aes(x = operator_label, y = est_prob, fill = factor(grade))) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7, color = "black") +
  geom_point(aes(y = obs_prob), position = position_dodge(width = 0.8), shape = 21, fill = "white", size = 2, show.legend = FALSE) +
  facet_wrap(~ task_label, scales = "free_x") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0, 1)) +
  scale_fill_brewer(palette = "Blues", name = "Grade Level") +
  labs(
    x = "Response Operator",
    y = "Choice Probability",
    title = "Observed and categorical-model-estimated operator probabilities across grades"
  ) +
  theme(
    legend.position = "bottom",
    axis.text.x = element_text(angle = 15, hjust = 1)
  )

ggsave("figures/Figure_2.pdf", p2, width = 9.5, height = 5.5)
ggsave("figures/Figure_2.png", p2, width = 9.5, height = 5.5, dpi = 300)
"""

fig3_code = common_header + """
cat("Generating Figure 3...\n")
df <- read_csv("data/figure3_primary_contrasts.csv", show_col_types = FALSE)

df <- df %>% mutate(
  task_label = case_when(
    task == "lowercase_identification" ~ "Lowercase Identification",
    task == "mirror" ~ "Mirror Task",
    task == "rotation" ~ "Rotation Task"
  ),
  operator_label = case_when(
    response_operator == "identity" ~ "Identity",
    response_operator == "left_right_reflection" ~ "Left-Right Reflection",
    response_operator == "top_bottom_reflection" ~ "Top-Bottom Reflection",
    response_operator == "rotation_180" ~ "180° Rotation"
  )
)

p3 <- ggplot(df, aes(x = operator_label, y = estimate, ymin = boot_ci_lower, ymax = boot_ci_upper)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_pointrange(size = 0.7, color = "navy") +
  facet_wrap(~ task_label, scales = "free_x") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  coord_flip() +
  labs(
    x = "Response Operator",
    y = "Probability Difference (Grades 3–5 minus Grades 1–2)"
  ) +
  theme(
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12),
    strip.text = element_text(size = 11)
  )

ggsave("figures/Figure_3.pdf", p3, width = 8, height = 4.5)
ggsave("figures/Figure_3.png", p3, width = 8, height = 4.5, dpi = 300)
"""

fig4_code = common_header + """
cat("Generating Figure 4...\n")
df <- read_csv("data/figure4_robustness_contrasts.csv", show_col_types = FALSE)

df <- df %>% mutate(
  spec_name = paste(analysis_family, model_specification, estimand, sep=" - "),
  operator_label = case_when(
    operator == "left_right_reflection" ~ "Left-Right Reflection",
    operator == "rotation_180" ~ "180° Rotation",
    TRUE ~ operator
  )
)

p4 <- ggplot(df, aes(x = estimate_pp, y = reorder(spec_name, estimate_pp), xmin = ci_low_pp, xmax = ci_high_pp, color = operator_label)) +
  geom_pointrange(position = position_dodge(width = 0.5)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~ operator_label, scales = "free_x") +
  theme_minimal() +
  theme(
    panel.border = element_rect(color = "black", fill = NA, size = 1),
    strip.background = element_rect(fill = "gray92", color = NA),
    strip.text = element_text(face = "bold", size = 11),
    legend.position = "none"
  ) +
  labs(
    x = "Estimated Difference (percentage points)",
    y = "Model Specification"
  )

ggsave("figures/Figure_4.pdf", p4, width = 10, height = 6)
ggsave("figures/Figure_4.png", p4, width = 10, height = 6, dpi = 300)
"""

figS1_code = common_header + """
cat("Generating Figure S1...\n")
df <- read_csv("data/figureS1_rotation_benchmarks.csv", show_col_types = FALSE)

# Explicitly use 34.5% as instructed
observed_val <- 0.345

p_s1 <- ggplot(df, aes(x = reorder(benchmark_name, expected_accuracy), y = expected_accuracy)) +
  geom_hline(yintercept = observed_val, color = "red", linetype = "solid", linewidth = 1) +
  geom_col(width = 0.5, fill = "gray70", color = "black") +
  geom_text(aes(label = paste0(round(expected_accuracy * 100, 1), "%")), vjust = -0.5, size = 3.5) +
  annotate("text", x = 1.5, y = observed_val + 0.015,
           label = paste0("Observed Rotation Accuracy: ", round(observed_val * 100, 2), "%"),
           color = "red", fontface = "bold", hjust = 0) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0, 0.45)) +
  coord_flip() +
  labs(
    x = "Chance Benchmark Model",
    y = "Expected Accuracy"
  )

ggsave("figures/Figure_S1.pdf", p_s1, width = 8, height = 4.5)
ggsave("figures/Figure_S1.png", p_s1, width = 8, height = 4.5, dpi = 300)
"""

figS2_code = common_header + """
cat("Generating Figure S2...\n")
df <- read_csv("data/figureS2_aic_comparison.csv", show_col_types = FALSE)

df <- df %>% mutate(
  task_label = case_when(
    task == "lowercase_identification" ~ "Lowercase ID",
    task == "mirror" ~ "Mirror Task",
    task == "rotation" ~ "Rotation Task"
  )
)

p_s2 <- ggplot(df, aes(x = model_type, y = aic, fill = model_type)) +
  geom_col(width = 0.6, color = "black", show.legend = FALSE) +
  facet_wrap(~ task_label, scales = "free_y") +
  scale_fill_brewer(palette = "Blues") +
  labs(
    x = "Grade Parameterization Model",
    y = "Akaike Information Criterion (AIC)"
  ) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave("figures/Figure_S2.pdf", p_s2, width = 8.5, height = 5)
ggsave("figures/Figure_S2.png", p_s2, width = 8.5, height = 5, dpi = 300)
"""

figS3_code = common_header + """
cat("Generating Figure S3...\n")
df <- read_csv("data/figureS3_school_contrasts.csv", show_col_types = FALSE)

df <- df %>% mutate(
  task_label = case_when(
    task == "lowercase_identification" ~ "Lowercase ID",
    task == "mirror" ~ "Mirror Task",
    task == "rotation" ~ "Rotation Task"
  ),
  operator_label = case_when(
    response_operator == "identity" ~ "Identity",
    response_operator == "left_right_reflection" ~ "Left-Right Reflection",
    response_operator == "top_bottom_reflection" ~ "Top-Bottom Reflection",
    response_operator == "rotation_180" ~ "180° Rotation"
  )
)

# Convert factor for correct ordering
df$school_sample <- factor(df$school_sample, levels = c("Pooled Adjusted", "School A", "School B"))

p_s3 <- ggplot(df, aes(x = school_sample, y = estimate, fill = school_sample)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_col(width = 0.6, color = "black", show.legend = FALSE) +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.2) +
  facet_grid(task_label ~ operator_label) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(values = c("Pooled Adjusted" = "gray30", "School A" = "steelblue", "School B" = "coral")) +
  labs(
    x = "Sample / Model",
    y = "Estimated Operator Difference (G3-5 minus G1-2)"
  ) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave("figures/Figure_S3.pdf", p_s3, width = 8.5, height = 6)
ggsave("figures/Figure_S3.png", p_s3, width = 8.5, height = 6, dpi = 300)
"""

all_figures_code = """
source("scripts/make_figure2.R")
source("scripts/make_figure3.R")
source("scripts/make_figure4.R")
source("scripts/make_figureS1.R")
source("scripts/make_figureS2.R")
source("scripts/make_figureS3.R")
cat("All figures generated successfully.\\n")
"""

with open(os.path.join(scripts_dir, "make_figure2.R"), "w", encoding="utf-8", newline="\n") as f: f.write(fig2_code)
with open(os.path.join(scripts_dir, "make_figure3.R"), "w", encoding="utf-8", newline="\n") as f: f.write(fig3_code)
with open(os.path.join(scripts_dir, "make_figure4.R"), "w", encoding="utf-8", newline="\n") as f: f.write(fig4_code)
with open(os.path.join(scripts_dir, "make_figureS1.R"), "w", encoding="utf-8", newline="\n") as f: f.write(figS1_code)
with open(os.path.join(scripts_dir, "make_figureS2.R"), "w", encoding="utf-8", newline="\n") as f: f.write(figS2_code)
with open(os.path.join(scripts_dir, "make_figureS3.R"), "w", encoding="utf-8", newline="\n") as f: f.write(figS3_code)
with open(os.path.join(scripts_dir, "make_all_figures.R"), "w", encoding="utf-8", newline="\n") as f: f.write(all_figures_code)

print("Figure generation scripts written.")
