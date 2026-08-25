# Red-team audit before any new submission

## Status

This branch is isolated from `master`. It is a redesign workspace. The private analysis workspace has now been inspected; no manuscript should be declared submission-ready until the demographic source is reconciled and the redesigned analyses are rerun.

## Findings that must be resolved

### 1. The private analysis data still encode Grade 1 = 43 and Grade 2 = 27

The corrected manuscript table reports Grade 1 = 44 and Grade 2 = 26, but the private authoritative analysis file `data_intermediate/trial_level_v3.csv` contains 43 Grade-1 participants and 27 Grade-2 participants. The public Figure 2 table is therefore consistent with the current private analysis file, not with the corrected Table 1.

Consequences:
- the old Grades 1-2 versus Grades 3-5 contrast is unchanged by a single 1/2 reassignment because both grades remain in the same broad group;
- five-grade plots, numeric-grade models, categorical-grade models, adjacent-grade contrasts, and grade-model comparisons cannot be finalized until the corrected participant-level grade source is identified;
- the corrected Table 1 and the current analysis dataset cannot both be treated as authoritative without reconciliation.

The current analysis table also has one Grade-2 child recorded as age 6 years. Because the corrected descriptive table gives a Grade-2 minimum of 7;04, this is a useful reconciliation flag, but it is not sufficient to identify the corrected participant without the source used to create the new age-by-grade table.

### 2. The reconstruction audit contains a demographic-resolution inconsistency

`scripts/prepare_data.py` explicitly builds analytical age and grade from the cohort spreadsheet (`age_sheet`, `grade_sheet`) while retaining raw PsychoPy values separately. However, `audit/discrepancy_log.csv` labels raw-versus-spreadsheet demographic mismatches with the resolution `Use raw value`.

One important example is P131: raw PsychoPy metadata report age 9 / Grade 4, while the spreadsheet reports age 7 / Grade 2. The analytical table uses the spreadsheet values despite the discrepancy log stating `Use raw value`.

This does not establish which source is correct. It establishes that the provenance/resolution text and the actual analytical choice disagree and must be reconciled before a new submission.

### 3. The rotation grade pattern is non-monotonic in the current data

The current categorical-grade robustness output shows left-right-reflection contrasts (percentage points):
- Grade 2 - Grade 1: -7.04, 95% CI [-24.80, 12.45]
- Grade 3 - Grade 2: -30.41, 95% CI [-44.69, -17.30]
- Grade 4 - Grade 3: +14.04, 95% CI [2.35, 27.37]
- Grade 5 - Grade 4: -4.70, 95% CI [-21.69, 12.10]

For correct 180-degree rotation:
- Grade 2 - Grade 1: -0.21, 95% CI [-13.96, 14.53]
- Grade 3 - Grade 2: +18.42, 95% CI [4.11, 32.76]
- Grade 4 - Grade 3: -0.93, 95% CI [-18.05, 16.30]
- Grade 5 - Grade 4: -3.71, 95% CI [-24.57, 19.50]

The broad two-group summary therefore conceals an important feature: the strongest observed rotation shift is concentrated around the Grade 2-to-3 boundary, not a simple monotonic progression across Grades 1-5.

For rotation, current AIC values are:
- categorical grade: 1045.26
- Grades 1-2 versus Grades 3-5: 1049.26
- piecewise step at Grade 3: 1051.79
- linear grade: 1070.89

These are diagnostic values only and must be regenerated after demographic reconciliation.

### 4. Exact chronological age is not present in the private analysis workspace

The private trial-level files contain integer age (`age_years`) plus integer raw age metadata. They do not contain DOB, exact age in months, or the participant-level exact ages used to create the corrected manuscript table (5;09 to 11;07 years).

Therefore the old continuous-age robustness analysis cannot simply be relabeled as exact chronological age. A final age-adjusted redesign requires the participant-level exact-age source used for the corrected table.

### 5. Age overlap must be modeled explicitly after exact ages are obtained

The corrected table implies adjacent-grade chronological-age common-support windows:
- Grades 1 and 2: 7;04 to 8;01
- Grades 2 and 3: 8;04 to 9;05
- Grades 3 and 4: 9;00 to 10;02
- Grades 4 and 5: 10;03 to 11;07

Participant counts inside those exact-age overlap windows cannot be reconstructed from the current private workspace because only integer ages are stored.

### 6. Socioeconomic covariates are available and should be tested, but the earlier claimed large income imbalance was incorrect

The private participant-level analysis data contain `family_income` and `guardian_education`. In the current 43/27 grade coding, family income below one minimum wage is 23/70 (32.9%) in Grades 1-2 and 20/72 (27.8%) in Grades 3-5. Thus there is not the previously claimed 48.6% versus 12.5% imbalance.

Nevertheless, family income and guardian education are plausible confounders and should be included in prespecified sensitivity models after the demographic source is reconciled.

### 7. The existing random-intercept sensitivity is not cleanly converged for rotation

`analysis_remaining_robustness/03_repeated_measures/model_diagnostics.txt` records repeated `false convergence (8)` warnings for the rotation `mblogit` random-intercept model. The next manuscript must not state that all random-intercept models converged cleanly. Either the sensitivity model must be stabilized/replaced or its instability must be reported.

## Redesigned inferential hierarchy

### Primary grade analysis

For each task:

`operator ~ factor(grade) + sex + school + base_letter + centered_trial_index`

- Treat Grades 1-5 separately.
- Report standardized operator probabilities for every grade with participant-cluster bootstrap 95% intervals.
- Report adjacent-grade probability contrasts and Grade 5 - Grade 1.
- Do not make the former Grades 1-2 versus Grades 3-5 dichotomy the primary result.

### Exact-age analysis

After exact participant ages are obtained:

1. Linear age:
`operator ~ age_months_centered + sex + school + base_letter + centered_trial_index`

2. Flexible age sensitivity, if estimable without instability:
`operator ~ ns(age_months_centered, df = 3) + sex + school + base_letter + centered_trial_index`

Report standardized age trajectories only over observed support.

### Joint age-grade sensitivity

For each task:

`operator ~ factor(grade) + age_months_centered + sex + school + base_letter + centered_trial_index`

Before interpreting marginal contrasts, report:
- grade-age association;
- design-matrix rank and condition number;
- participant counts by grade and exact-age support;
- overlap diagnostics.

This is a conditional association model, not a causal schooling model.

### Adjacent-grade common-support analysis

For each adjacent pair, restrict to participants whose exact chronological ages lie in the overlap of the two grades' observed age ranges. Within that common support, fit the grade contrast with exact age retained as a covariate. Report participant counts, trials, standardized probability difference, participant-cluster bootstrap interval, convergence, and sparse categories.

If common support is too sparse for stable estimation, report that rather than forcing an estimate.

### Secondary historical comparison

The old Grades 1-2 versus Grades 3-5 contrast can be retained only as a secondary comparison to the previous cohort report.

### Additional mandatory sensitivity analyses

- family-income and guardian-education adjustment;
- sex-by-grade probability-scale heterogeneity;
- school-by-grade probability-scale heterogeneity;
- leave-one-school-out analysis;
- repeated-measures sensitivity with a model that demonstrably converges, or explicit reporting of instability;
- participant-grouped predictive comparison of categorical grade, linear grade, broad grade group, age-only, and joint age-grade specifications;
- sparse-cell and separation diagnostics for every multinomial fit.

## Claim rules

Do not use the following without stronger design support:
- developmental change
- effect of schooling
- effect of literacy instruction
- maturation effect
- neural mechanism
- acquisition versus consolidation as an empirically identified discontinuity

Defensible framing is cross-sectional association with school grade and/or chronological age.

## Remaining input blocker

The private workspace is now available, including participant-level trial data and socioeconomic covariates. The remaining blocker is the participant-level demographic source that produced the corrected Table 1: corrected Grade 1 = 44, Grade 2 = 26 and exact chronological ages in months (or DOB plus testing date). That source must be reconciled with `trial_level_v3.csv` before final grade-specific or exact-age analyses are run.
