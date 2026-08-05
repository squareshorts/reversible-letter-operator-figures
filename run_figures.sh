#!/usr/bin/env bash
set -e

echo "Restoring renv environment..."
Rscript -e "if (!requireNamespace('renv', quietly=TRUE)) install.packages('renv', repos='http://cran.us.r-project.org'); renv::restore(prompt=FALSE)"

echo "Validating inputs..."
Rscript scripts/validate_inputs.R

echo "Generating figures..."
Rscript scripts/make_all_figures.R

echo "Verifying outputs..."
Rscript scripts/verify_outputs.R

echo "Running tests..."
Rscript tests/test_all.R

echo "All tasks completed successfully."
