options(stringsAsFactors = FALSE, warn = 1)
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

cat("Generating Figure 4...
")
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
