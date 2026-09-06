# Reversible-letter rotation judgments: reproducibility repository

This repository supports the manuscript:

**Left-right and top-bottom reflection errors diverge between Grades 2 and 3 in reversible-letter rotation judgments**

prepared for the *Cortex* special issue **Challenging assumptions in neuropsychology**.

## What is public here

The repository contains non-identifying aggregate results, figure-generation code, validation tests, and the statistical model specification for the submitted analyses. Participant-level records are not included because the study involved children and the original consent and ethics framework did not authorize unrestricted public release.

The inferential analyses use participant-level trial data under controlled access. `scripts/cortex_models.R` encodes the models reported in the Cortex submission and expects a restricted trial-level file with the schema documented in `docs/restricted_data_schema.md`. The public aggregate snapshot in `data/cortex_submission_results.csv` records the numerical results reported in the submitted manuscript.

## Analysis represented in the Cortex submission

The submission treats grade as a five-level categorical factor and analyzes the three response categories separately within lowercase identification, mirror judgment, and rotation judgment. Nominal multinomial generalized estimating equations cluster the four trials within participant and use robust sandwich covariance. Exact chronological age is modeled explicitly, with spline, socioeconomic, sex-interaction, age-overlap, and error-composition sensitivity analyses. The rotation error-only analysis removes correct rotation trials and compares left-right with top-bottom reflection errors using participant-clustered binary logistic GEE.

See `docs/methods_summary.md` and `docs/reproduction_scope.md` for the exact public/private reproducibility boundary.

## Figure reproduction

The existing aggregate figure pipeline can be run with:

**Windows**
```powershell
.\run_figures.ps1
```

**macOS/Linux**
```bash
./run_figures.sh
```

The repository preserves the aggregate figure inputs so that no participant-level data are required for figure regeneration.

## Restricted data

The restricted analysis table contains participant identifiers, school, sex, grade, exact age, socioeconomic variables, task, trial index, base letter, response category, and correctness. No names, dates of birth, or raw identifying files are part of this public repository. Requests for deidentified participant-level data require ethics approval, institutional authorization, and an appropriate data-use agreement.

## Citation and archival release

`CITATION.cff` and `.zenodo.json` contain the metadata for the Cortex submission snapshot. A versioned Zenodo archive will be minted from the frozen repository release; the DOI will be added here after publication of that archive.

## Repository integrity

The repository includes validation tests and environment metadata. The original figure-reproduction scripts remain available under `scripts/`, while the Cortex inferential model specification is in `scripts/cortex_models.R`.
