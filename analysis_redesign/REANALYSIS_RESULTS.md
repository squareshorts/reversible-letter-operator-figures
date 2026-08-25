# Reanalysis results for manuscript redesign

## Decision-level result

The old Grades 1-2 versus Grades 3-5 contrast should not remain the primary analysis. The five-grade pattern is nonlinear, and the strongest stable signal is in the rotation task.

Across all 142 participants and 1,704 trials, categorical grade was associated with operator choice in all three tasks in models adjusted for sex, school, base letter, and within-block trial index. However, when age was added, the evidence for a grade contribution was robust only for rotation:

| Task | Grade beyond numeric recorded age, LR chi-square (df=8) | p | Grade beyond categorical recorded age, LR chi-square (df=8) | p |
|---|---:|---:|---:|---:|
| Lowercase identification | 14.07 | .080 | 10.36 | .241 |
| Mirror judgment | 16.41 | .037 | 8.93 | .348 |
| Rotation judgment | 49.40 | <.001 | 56.31 | <.001 |

After Benjamini-Hochberg correction across the three task-level tests, only rotation remained below .05 for the grade-beyond-numeric-age comparison.

## Socioeconomic sensitivity

Participant-level family income and guardian education are available. When both were added to the age-adjusted models, the grade contribution in rotation remained very strong:

- numeric recorded age + SES: LR chi-square(8) = 48.25, p = 8.84e-08, BH-adjusted across tasks = 2.65e-07;
- categorical recorded age + SES: LR chi-square(8) = 58.72, p = 8.32e-10, BH-adjusted across tasks = 2.49e-09.

The corresponding grade contribution was not robust across age representations for lowercase identification or mirror judgment.

## Five-grade rotation pattern

Existing 2,000-participant cluster-bootstrap contrasts from the current dataset show:

| Adjacent contrast | Operator | Difference (pp) | 95% bootstrap CI |
|---|---|---:|---:|
| Grade 2 - Grade 1 | Left-right reflection | -7.0 | [-24.8, 12.4] |
|  | Correct 180-degree rotation | -0.2 | [-14.0, 14.5] |
|  | Top-bottom reflection | +7.3 | [-7.9, 21.6] |
| Grade 3 - Grade 2 | Left-right reflection | -30.4 | [-44.7, -17.3] |
|  | Correct 180-degree rotation | +18.4 | [4.1, 32.8] |
|  | Top-bottom reflection | +12.0 | [-1.8, 26.8] |
| Grade 4 - Grade 3 | Left-right reflection | +14.0 | [2.3, 27.4] |
|  | Correct 180-degree rotation | -0.9 | [-18.1, 16.3] |
|  | Top-bottom reflection | -13.1 | [-27.2, 1.3] |
| Grade 5 - Grade 4 | Left-right reflection | -4.7 | [-21.7, 12.1] |
|  | Correct 180-degree rotation | -3.7 | [-24.6, 19.5] |
|  | Top-bottom reflection | +8.4 | [-11.4, 27.1] |

The pattern is therefore not a monotonic grade trend. The dominant discontinuity in the current data is the reduction in left-right reflection between Grades 2 and 3, followed by partial rebound in Grade 4.

## Direct age-overlap sensitivity

The current trial-level archive contains age in completed years, not exact age in months. A within-age sensitivity can nevertheless compare Grade 2 and Grade 3 children who are all recorded as 8 years old (10 Grade-2 and 14 Grade-3 participants).

For the rotation task, adjusting for sex, school, base letter, and trial index:

- left-right reflection: Grade 3 - Grade 2 = -26.4 pp, 95% cluster-robust CI [-40.2, -12.6];
- correct 180-degree rotation: +24.4 pp, 95% CI [-1.1, 50.0];
- top-bottom reflection: +2.0 pp, 95% CI [-22.7, 26.7].

Adding family income and guardian education:

- left-right reflection: -28.0 pp, 95% CI [-44.5, -11.4];
- correct 180-degree rotation: +28.1 pp, 95% CI [6.1, 50.1];
- top-bottom reflection: -0.1 pp, 95% CI [-28.7, 28.4].

This directly addresses the objection that the grade result is merely created by broad chronological-age differences, while remaining a secondary sensitivity because age is only recorded to whole years in the analysis archive.

## Predictive comparison

Participant-grouped five-fold cross-validation does not show a large predictive advantage for the more complex grade representation. For rotation, mean multiclass log loss was approximately 0.9502 for joint categorical grade + numeric age, 0.9505 for categorical grade, and 0.9506 for the old broad grade group. The inferential value of categorical grade therefore comes from exposing the nonlinear response structure, not from a claim of large out-of-sample predictive superiority.

## Data/provenance blockers before GO

1. The private analytical file still contains Grade 1 n=43 and Grade 2 n=27, whereas the corrected manuscript table supplied later reports 44 and 26. Broad 1-2 versus 3-5 results are unaffected, but every five-grade result must be reconciled before submission.
2. Exact participant ages in months (or DOB + individual testing date) used to build the corrected age table are not present in the uploaded analysis workspace. They are required for a final exact-age joint analysis.
3. The reconstruction discrepancy log says demographic mismatches should use the raw value, while the actual preparation script uses the cohort spreadsheet value. The resolution rule must be made explicit and consistent.
4. The previous multinomial random-intercept rotation sensitivity produced false-convergence warnings. It should not be described as cleanly converged in the revised manuscript.

## Manuscript consequence

The revised paper should be framed around **nonlinear grade-associated redistribution in rotation choices**, with lowercase and mirror tasks as contextual secondary analyses. It should not claim a general monotonic developmental progression or an effect of literacy instruction.
