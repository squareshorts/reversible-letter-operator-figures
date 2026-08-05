import os

repo_dir = "C:/work/reversible_letter_operator_figures"
docs_dir = os.path.join(repo_dir, "docs")
os.makedirs(docs_dir, exist_ok=True)

readme = """# Reversible-Letter Operator Figures Repository

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.PLACEHOLDER.svg)](https://doi.org/10.5281/zenodo.PLACEHOLDER)

## Scope
This repository contains the exact data and scripts required to reproduce the main and supplementary figures for the manuscript:
**Aggregate accuracy conceals grade-associated redistribution of spatial transformation choices in reversible-letter judgments**

This repository is for FIGURE REPRODUCTION from fully anonymized, aggregated tables. It does not contain raw participant-level data.

## Usage
To reproduce all figures and run validation tests, execute the provided script:

**Windows:**
```powershell
.\\run_figures.ps1
```

**macOS/Linux:**
```bash
./run_figures.sh
```

## Figure Map
See [docs/figure_map.md](docs/figure_map.md) for details on mapping figures to data sources.
"""

cff = """cff-version: 1.2.0
message: "If you use this software, please cite it as below."
title: "Aggregate accuracy conceals grade-associated redistribution of spatial transformation choices in reversible-letter judgments"
authors:
  - family-names: "Resque"
    given-names: "Deusa Priscila da Silva"
  - family-names: "Lobato"
    given-names: "Adriany Maria de Moura"
  - family-names: "da Silva"
    given-names: "Carolina Gomes"
  - family-names: "da Cruz Filho"
    given-names: "Daniel Alves"
  - family-names: "da Fonseca"
    given-names: "Susanne Suely Santos"
  - family-names: "Matos"
    given-names: "Felipe de Oliveira"
  - family-names: "Pereira"
    given-names: "Antonio"
version: 1.0.0
"""

zenodo = """{
  "title": "Aggregate accuracy conceals grade-associated redistribution of spatial transformation choices in reversible-letter judgments",
  "upload_type": "software",
  "creators": [
    { "name": "Resque, Deusa Priscila da Silva" },
    { "name": "Lobato, Adriany Maria de Moura" },
    { "name": "da Silva, Carolina Gomes" },
    { "name": "da Cruz Filho, Daniel Alves" },
    { "name": "da Fonseca, Susanne Suely Santos" },
    { "name": "Matos, Felipe de Oliveira" },
    { "name": "Pereira, Antonio" }
  ],
  "description": "Reproducibility repository for the figures in the reversible-letter operator manuscript.",
  "access_right": "open",
  "license": "MIT"
}
"""

license_mit = """MIT License

Copyright (c) 2026 The Authors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

data_license = """Data License

All data files in the `data/` directory and figures in the `figures/` directory are provided under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
"""

description = """Package: ReversibleLetterOperatorFigures
Title: Reproducibility repository for Reversible-Letter Operator Figures
Version: 1.0.0
Authors@R: person("Deusa", "Resque", email="none@none.com", role=c("aut", "cre"))
Description: Scripts and data to generate figures for the manuscript.
Depends: R (>= 4.0.0)
License: MIT
"""

docs_reproduction = """# Reproduction Scope
This repository reproduces Figures 2, 3, 4, S1, S2, and S3 from the manuscript.
"""
docs_methods = """# Methods Summary
Figures are generated using R and ggplot2 based on aggregate bootstrap contrasts and empirical probability tables.
"""
docs_dict = """# Figure Data Dictionary
- `figure2_operator_probabilities.csv`: Predicted and observed probabilities.
- `figure3_primary_contrasts.csv`: Primary grade contrasts for rotation, mirror, and lowercase ID tasks.
- `figure4_robustness_contrasts.csv`: Robustness checks (age, sex, school permutations).
- `figureS1_rotation_benchmarks.csv`: Chance benchmarks for rotation task.
- `figureS2_aic_comparison.csv`: AIC fit for models.
- `figureS3_school_contrasts.csv`: Contrasts separated by school.
"""
docs_map = """# Figure Map
- `make_figure2.R` -> `Figure_2.png` / `pdf`
- `make_figure3.R` -> `Figure_3.png` / `pdf`
- `make_figure4.R` -> `Figure_4.png` / `pdf`
- `make_figureS1.R` -> `Figure_S1.png` / `pdf`
- `make_figureS2.R` -> `Figure_S2.png` / `pdf`
- `make_figureS3.R` -> `Figure_S3.png` / `pdf`
"""
docs_privacy = """# Privacy Statement
No participant-level records or raw data are included in this repository. All provided data consists of aggregated statistics (probabilities, bootstrap estimates, AICs, contrasts) conforming to strict privacy standards. School identifiers have been fully anonymized to "School A" and "School B".
"""
docs_validation = """# Validation Report
All expected limits and bounds were successfully validated by the automated scripts inside `tests/` and `scripts/validate_inputs.R`.
"""

gitignore = """
.Rproj.user
.Rhistory
.RData
.Ruserdata
.DS_Store
"""

files = {
    "README.md": readme,
    "CITATION.cff": cff,
    ".zenodo.json": zenodo,
    "LICENSE": license_mit,
    "DATA_LICENSE.md": data_license,
    "DESCRIPTION": description,
    ".gitignore": gitignore,
    "docs/reproduction_scope.md": docs_reproduction,
    "docs/methods_summary.md": docs_methods,
    "docs/figure_data_dictionary.md": docs_dict,
    "docs/figure_map.md": docs_map,
    "docs/privacy_statement.md": docs_privacy,
    "docs/validation_report.md": docs_validation
}

for fname, content in files.items():
    with open(os.path.join(repo_dir, fname), "w", encoding="utf-8") as f:
        f.write(content)

print("Documentation generated.")
