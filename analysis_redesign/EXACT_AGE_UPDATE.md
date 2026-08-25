# Exact-age redesign update

This file contains aggregate/non-identifying results only. Participant names, DOBs, and private reconciliation records are not stored in this public repository.

## Final analytical cohort

The final analytical cohort contains 142 children across Grades 1-5: 43/27/32/21/19. Exact chronological age is now available for all 142 participants. Mean age is 8 years 7 months (SD 17.3 months), with a range of 6 years 4 months to 11 years 7 months.

One participant had two complete administrations. The later administration was retained as primary following clarification from the data-collection team. Repeating the principal rotation models with the earlier administration produced the same inferential conclusion. Apparent duplicate identities in the demographic spreadsheet did not correspond to additional complete raw sessions and therefore did not justify participant exclusion.

## Grade beyond exact chronological age

Nested multinomial likelihood-ratio tests compare categorical grade with the corresponding exact-age model (df=8; n=142, 568 trials per task).

| Task | Linear exact age | Cubic B-spline exact age |
|---|---:|---:|
| Lowercase identification | chi2=10.64, p=.223 | chi2=8.37, p=.398 |
| Mirror judgment | chi2=23.71, p=.00257; BH=.00385 | chi2=15.85, p=.0446; BH=.0668 |
| Rotation judgment | chi2=44.77, p=4.06e-7; BH=1.22e-6 | chi2=49.88, p=4.30e-8; BH=1.29e-7 |

With binary family-income and guardian-education sensitivity adjustment:

| Task | Linear exact age + SES | Cubic B-spline exact age + SES |
|---|---:|---:|
| Lowercase identification | chi2=12.48, p=.131 | chi2=9.81, p=.278 |
| Mirror judgment | chi2=18.73, p=.0164; BH=.0246 | chi2=10.59, p=.226; BH=.278 |
| Rotation judgment | chi2=41.92, p=1.40e-6; BH=4.20e-6 | chi2=48.96, p=6.47e-8; BH=1.94e-7 |

Rotation is the only task robust across all exact-age and socioeconomic specifications.

## Rotation localization

Two thousand participant-cluster bootstrap replicates localized the largest adjacent transition to Grade 3 minus Grade 2:

- left-right reflection: -30.10 percentage points, 95% CI [-43.66, -18.48];
- correct 180-degree rotation: +18.26 points, 95% CI [4.33, 32.59];
- top-bottom reflection: +11.84 points, 95% CI [-2.61, 26.28].

The Grade-4-minus-Grade-3 left-right contrast partially reverses (+14.15 points, 95% CI [2.26, 28.20]), confirming a nonlinear rather than monotonic grade pattern.

## Exact-age common support

Grades 2 and 3 overlap in exact age from 8.383 to 9.501 years. The interval contains 35 participants (7 Grade 2, 28 Grade 3).

Adjusted for exact age and design covariates:
- left-right reflection: -21.13 pp, 95% cluster-robust CI [-43.57, 1.32];
- correct rotation: +15.84 pp, CI [-1.05, 32.72].

With binary SES adjustment:
- left-right reflection: -30.29 pp, CI [-69.29, 8.71];
- correct rotation: +24.31 pp, CI [8.78, 39.84].

This local analysis is supportive but not the primary inferential basis because the common-support Grade-2 sample is small.

## Repeated-measures sensitivity

A nominal GEE with exchangeable within-participant correlation converged for both rotation specifications:

- exact age: Wald chi2(8)=22.71, p=.003754;
- exact age + binary SES: Wald chi2(8)=23.49, p=.002784.

## Duplicate-session sensitivity

Using the earlier rather than later administration for the one participant with two complete sessions leaves the principal rotation conclusion effectively unchanged. The session-selection rule therefore does not determine the result.

## Manuscript consequence

The manuscript should center the nonlinear grade-associated redistribution in rotation choices. Lowercase identification does not show an independent categorical-grade contribution after exact-age adjustment. Mirror judgment is not robust to the flexible exact-age + SES specification. The appropriate inference is a cross-sectional grade-associated response pattern, not a causal effect of schooling, literacy instruction, or maturation.
