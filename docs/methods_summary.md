# Methods summary for the Cortex submission

Responses are classified by the geometric relation between the displayed stimulus and the selected alternative. The three tasks are modeled separately.

## Primary clustered multinomial models

Nominal multinomial generalized estimating equations are fitted with `multgee::nomLORgee`, treating participant as the cluster and the four within-task trials as repeated observations. Robust sandwich covariance is used for inference. The primary age-adjusted model is:

```text
response_category ~ factor(grade) + exact_age_years + sex + school + factor(base_letter) + centered_trial_index
```

Grade is tested jointly across the two baseline-category logits. The unadjusted grade model omits exact age. Rotation sensitivity models replace linear exact age with cubic B-splines having 3, 4, or 5 degrees of freedom. The socioeconomic model adds family income and guardian education. A grade-by-sex interaction model adds `factor(grade) * sex`.

## Grade-2/Grade-3 common-support analysis

For rotation, Grades 2 and 3 are compared after restricting the data to their observed exact-age overlap. Unused grade levels are dropped before fitting the same three-category clustered nominal model.

## Error-composition analysis

Correct 180-degree rotation responses are removed. The remaining reflection errors are coded as left-right versus top-bottom and analyzed with participant-clustered binary logistic GEE:

```text
left_right_error ~ grade3_vs_grade2 + exact_age_years + sex + school + factor(base_letter) + centered_trial_index
```

A spline-age sensitivity replaces linear age with `splines::bs(exact_age_years, df = 3)`. The focal odds ratio compares Grade 3 with Grade 2 for the odds that an error is a left-right reflection rather than a top-bottom reflection.

## Software

The submitted analyses were run in R 4.5.2. Nominal multinomial GEE uses `multgee`; spline bases use `splines`; binary GEE uses a standard logistic GEE implementation with participant clustering. The public script `scripts/cortex_models.R` records the model formulas and validation checks. Participant-level data are controlled-access and are not committed to the public repository.
