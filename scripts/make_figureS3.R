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

cat("Generating Figure S3...
")
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
