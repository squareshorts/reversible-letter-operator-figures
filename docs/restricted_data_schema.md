# Restricted analysis-table schema

The participant-level table required for full inferential reproduction is not public. A controlled-access copy should contain one row per scored trial and the following fields.

| Variable | Description |
|---|---|
| participant_id | Pseudonymous participant code; no names or direct identifiers |
| school | Anonymized school label |
| sex | Participant sex as coded in the source cohort |
| grade | School grade, 1 through 5 |
| exact_age_years | Exact chronological age at testing in decimal years; missing only where linkage was unresolved |
| family_income | Study socioeconomic category used in sensitivity analysis |
| guardian_education | Guardian-education category used in sensitivity analysis |
| task | `lowercase_identification`, `mirror`, or `rotation` |
| trial_index | Within-block trial index, 1 through 4 |
| centered_trial_index | Centered version of trial index used in models |
| base_letter | Target/base letter: b, d, p, or q |
| response_category | Geometric stimulus-response category for that task |
| correct | Binary correctness indicator |

Expected invariant counts for the submitted dataset are 142 participants, 1,704 scored trials, 568 trials per task, 12 scored trials per participant, and four trials per participant within each task. The exact-age models include the subset with unambiguous exact-age linkage.

No names, dates of birth, source filenames containing identifying information, or raw demographic spreadsheets belong in the public repository or archival release.
