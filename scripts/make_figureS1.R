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

cat("Generating Figure S1...
")
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
