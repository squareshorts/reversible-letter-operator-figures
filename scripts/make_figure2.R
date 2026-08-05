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

cat("Generating Figure 2...
")
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
