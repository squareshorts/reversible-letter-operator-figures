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

cat("Generating Figure S2...
")
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
