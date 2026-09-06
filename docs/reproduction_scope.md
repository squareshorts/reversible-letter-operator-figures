# Reproduction scope

The public repository has two reproducibility layers.

1. **Fully public aggregate reproduction.** The files under `data/` and the existing scripts under `scripts/` reproduce the non-identifying figures and validate the published aggregate tables without access to participant-level records.

2. **Restricted-data inferential reproduction.** `scripts/cortex_models.R` contains the model specifications used for the Cortex submission. It expects the controlled-access trial-level table described in `docs/restricted_data_schema.md`. This layer covers the nominal multinomial GEE analyses, exact-age and spline sensitivities, socioeconomic adjustment, grade-by-sex sensitivity, Grade-2/Grade-3 age-overlap analysis, and the binary GEE analysis of rotation-error composition.

The public file `data/cortex_submission_results.csv` is a frozen non-identifying numerical snapshot of the inferential results reported in the submitted manuscript. It permits claim checking even when the restricted participant-level table cannot be redistributed.

The repository does **not** claim that participant-level analyses can be rerun from public data alone. That restriction is intentional and reflects the consent and ethics conditions for this cohort of children.
