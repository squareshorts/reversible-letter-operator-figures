# Red-team audit before any new submission

## Status

This branch is isolated from `master`. It is a redesign workspace; no manuscript should be declared submission-ready from the current public aggregate outputs.

## Findings that must be resolved

### 1. Grade-specific public outputs are inconsistent with the corrected participant table

The corrected manuscript table reports Grade 1 = 44 and Grade 2 = 26. The current public Figure 2 table encodes Grade 1 = 43 and Grade 2 = 27. This is identifiable from the exact observed proportions and task trial totals: Grade 1 probabilities have denominator 172 (= 43 participants x 4 trials) and Grade 2 probabilities have denominator 108 (= 27 x 4), and these denominators sum with Grades 3-5 to all 568 task trials.

Consequences:
- the old Grades 1-2 versus Grades 3-5 contrast is not changed by moving one child between Grades 1 and 2, because both grades are in the same broad group;
- five-grade plots, numeric-grade models, categorical-grade models, adjacent-grade contrasts, and grade-model comparisons must be regenerated from the authoritative corrected participant-level data;
- the corrected Table 1 and the current public Figure 2 cannot both be treated as authoritative without reconciliation.

### 2. The rotation grade pattern is non-monotonic

The current aggregate categorical-grade robustness output shows the left-right-reflection contrasts (percentage points):
- Grade 2 - Grade 1: -7.04, 95% CI [-24.80, 12.45]
- Grade 3 - Grade 2: -30.41, 95% CI [-44.69, -17.30]
- Grade 4 - Grade 3: +14.04, 95% CI [2.35, 27.37]
- Grade 5 - Grade 4: -4.70, 95% CI [-21.69, 12.10]

For correct 180-degree rotation:
- Grade 2 - Grade 1: -0.21, 95% CI [-13.96, 14.53]
- Grade 3 - Grade 2: +18.42, 95% CI [4.11, 32.76]
- Grade 4 - Grade 3: -0.93, 95% CI [-18.05, 16.30]
- Grade 5 - Grade 4: -3.71, 95% CI [-24.57, 19.50]

The old broad two-group summary therefore conceals an important feature: the strongest observed shift is concentrated around the Grade 2-to-3 boundary, not a simple monotonic progression across Grades 1-5.

For the rotation task, current AIC values are:
- categorical grade: 1045.26
- Grades 1-2 versus Grades 3-5: 1049.26
- piecewise step at Grade 3: 1051.79
- linear grade: 1070.89

The categorical representation is therefore the best of these four by AIC for the rotation task. These values are diagnostic only and must be regenerated after grade reconciliation.

### 3. Exact chronological age must replace the old age robustness variable

The corrected participant table reports exact chronological ages derived from date of birth and testing date for all 142 children, with an overall range of 5 years 9 months to 11 years 7 months. The old robustness analysis used a recorded age-in-years variable. Its age contrasts must not be carried into a new manuscript without rerunning them using exact age in months.

### 4. Age overlap is a design feature that must be modeled explicitly

The corrected table implies adjacent-grade chronological-age common-support windows:
- Grades 1 and 2: 7;04 to 8;01
- Grades 2 and 3: 8;04 to 9;05
- Grades 3 and 4: 9;00 to 10;02
- Grades 4 and 5: 10;03 to 11;07

Participant counts within these overlap windows cannot be obtained from the public aggregate repository. They must be computed from exact participant-level ages before conditional grade effects are interpreted.

### 5. Socioeconomic imbalance is a prospective reviewer concern

The published cohort table shows a large family-income imbalance across the old broad grade groups. Pooling sex strata from the published table gives:
- Grades 1-2: 34/70 (48.6%) at <=1 minimum wage
- Grades 3-5: 9/72 (12.5%) at <=1 minimum wage

Family-tutor education also differs strongly across the published broad groups. If participant-level socioeconomic variables exist in the authoritative workspace, the redesigned analysis must include prespecified sensitivity models for family income and tutor education. If they are not available at participant level, the manuscript must state that they could not be adjusted and must not attribute grade associations specifically to instruction or maturation.

## Redesigned inferential hierarchy

### Primary grade analysis

For each task:

`operator ~ factor(grade) + sex + school + base_letter + centered_trial_index`

- Treat Grades 1-5 separately.
- Report standardized operator probabilities for every grade with participant-cluster bootstrap 95% intervals.
- Report adjacent-grade probability contrasts and Grade 5 - Grade 1.
- Do not make the former Grades 1-2 versus Grades 3-5 dichotomy the primary result.

### Exact-age analysis

Use exact chronological age in months.

1. Linear age:
`operator ~ age_months_centered + sex + school + base_letter + centered_trial_index`

2. Flexible age sensitivity, if estimable without instability:
`operator ~ ns(age_months_centered, df = 3) + sex + school + base_letter + centered_trial_index`

Report standardized age trajectories on the observed support. Avoid predictions outside the observed age range.

### Joint age-grade sensitivity

For each task:

`operator ~ factor(grade) + age_months_centered + sex + school + base_letter + centered_trial_index`

Before interpreting coefficients or marginal contrasts, report:
- grade-age association;
- design-matrix rank and condition number;
- participant counts by grade and exact-age support;
- overlap diagnostics.

This is a conditional association model, not a causal schooling model.

### Adjacent-grade common-support analysis

For each adjacent pair of grades, restrict to participants whose exact chronological ages lie in the overlap of the two grades' observed age ranges. Within that common support, fit the grade contrast with exact age retained as a covariate. Report participant counts in each grade, trials, standardized probability difference, participant-cluster bootstrap interval, convergence, and any sparse category.

If common support is too sparse for a stable model, report the instability rather than forcing an estimate.

### Secondary historical comparison

The old Grades 1-2 versus Grades 3-5 contrast can be retained only as a secondary comparison to the 2023 cohort report, clearly labeled as such.

### Additional mandatory sensitivity analyses

- participant-random-intercept or otherwise genuinely correlated multinomial model;
- sex-by-grade probability-scale heterogeneity;
- school-by-grade probability-scale heterogeneity;
- family-income and tutor-education adjustment if participant-level fields are available;
- leave-one-school-out analysis;
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

## Input blocker

The public repository intentionally contains only anonymized aggregate figure tables. Its builder points to the private local workspace `C:/work/letter_operator_reanalysis`. Exact-age, socioeconomic, and participant-level common-support analyses cannot be executed from the public repository alone.

Required private input is an authoritative deidentified participant-trial table (or the private analysis workspace) containing participant ID, corrected grade, exact age or DOB/testing dates, sex, school, task, trial index, base letter, operator/response, and—if available—family income and tutor education. Raw identifiable data should not be committed to this public repository.
