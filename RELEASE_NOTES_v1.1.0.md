# v1.1.0 — Cortex submission reproducibility snapshot

This release retargets the public repository to the Cortex manuscript:

**Left-right and top-bottom reflection errors diverge between Grades 2 and 3 in reversible-letter rotation judgments**

## Included

- Existing aggregate figure-reproduction data and scripts.
- `scripts/cortex_models.R`, recording the clustered nominal multinomial GEE, exact-age, spline-age, socioeconomic, grade-by-sex, common-support, and error-composition model specifications used in the submission.
- `data/cortex_submission_results.csv`, a frozen non-identifying numerical snapshot of the inferential results reported in the manuscript.
- `docs/restricted_data_schema.md`, documenting the controlled-access participant-level table required for complete inferential reruns.
- Updated privacy, methods, reproduction-scope, citation, and Zenodo metadata.
- Corrected GitHub Actions configuration for the repository's `master` branch.

## Data-access boundary

Participant-level records are not included. The cohort consists of children and the original consent/ethics framework did not authorize unrestricted public release. Deidentified participant-level data may be made available under controlled access subject to ethics approval, institutional authorization, and a data-use agreement.

## Intended archive

This repository state is intended to be frozen as version `v1.1.0` and deposited in Zenodo. The Zenodo DOI should be added to the manuscript and README after the archive is minted.
