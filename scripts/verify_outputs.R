cat("Verifying outputs...\n")

expected_files <- c(
  "figures/Figure_2.pdf", "figures/Figure_2.png",
  "figures/Figure_3.pdf", "figures/Figure_3.png",
  "figures/Figure_4.pdf", "figures/Figure_4.png",
  "figures/Figure_S1.pdf", "figures/Figure_S1.png",
  "figures/Figure_S2.pdf", "figures/Figure_S2.png",
  "figures/Figure_S3.pdf", "figures/Figure_S3.png"
)

missing <- c()
for (f in expected_files) {
  if (!file.exists(f)) {
    missing <- c(missing, f)
  }
}

if (length(missing) > 0) {
  stop("Output verification failed. Missing files: ", paste(missing, collapse = ", "))
}

cat("Output verification passed! All figures generated successfully.\n")
