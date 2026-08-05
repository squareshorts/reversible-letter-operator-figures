$ErrorActionPreference = "Stop"

Write-Host "Restoring renv environment..."
Rscript -e "if (!requireNamespace('renv', quietly=TRUE)) install.packages('renv', repos='http://cran.us.r-project.org'); renv::restore(prompt=FALSE)"

Write-Host "Validating inputs..."
Rscript scripts/validate_inputs.R

Write-Host "Generating figures..."
Rscript scripts/make_all_figures.R

Write-Host "Verifying outputs..."
Rscript scripts/verify_outputs.R

Write-Host "Running tests..."
Rscript tests/test_all.R

Write-Host "All tasks completed successfully."
