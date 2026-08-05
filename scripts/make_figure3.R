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

cat("Generating Figure 3...
")
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
