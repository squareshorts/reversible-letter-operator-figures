#!/usr/bin/env Rscript

# Cortex submission model specification
# -------------------------------------
# This script records and fits the inferential models reported in the Cortex
# submission when the controlled-access trial-level table is available.
# No participant-level data are distributed with this repository.

required_packages <- c("multgee", "geepack")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages)) {
  stop("Install required packages before running: ", paste(missing_packages, collapse = ", "))
}

input_path <- Sys.getenv("LETTER_ROTATION_RESTRICTED_DATA", unset = "restricted_data/trial_level_cortex.csv")
if (!file.exists(input_path)) {
  stop(
    "Restricted analysis table not found at '", input_path, "'. ",
    "Set LETTER_ROTATION_RESTRICTED_DATA to the controlled-access CSV path. ",
    "See docs/restricted_data_schema.md."
  )
}

d <- read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)

required_columns <- c(
  "participant_id", "school", "sex", "grade", "exact_age_years",
  "family_income", "guardian_education", "task", "trial_index",
  "centered_trial_index", "base_letter", "response_category", "correct"
)
missing_columns <- setdiff(required_columns, names(d))
if (length(missing_columns)) stop("Missing required columns: ", paste(missing_columns, collapse = ", "))

# Dataset invariants for the full retained cohort.
stopifnot(length(unique(d$participant_id)) == 142L)
stopifnot(nrow(d) == 1704L)
stopifnot(all(table(d$task) == 568L))
stopifnot(all(table(d$participant_id) == 12L))
stopifnot(all(table(d$participant_id, d$task)[table(d$participant_id, d$task) > 0] == 4L))

# Factors and ordering used in the submitted models.
d$grade <- factor(d$grade, levels = 1:5)
d$sex <- factor(d$sex)
d$school <- factor(d$school)
d$base_letter <- factor(d$base_letter, levels = c("b", "d", "p", "q"))
d$family_income <- factor(d$family_income)
d$guardian_education <- factor(d$guardian_education)

# multgee expects an occasion indicator for repeated observations within cluster.
# Each task has four scored trials per participant.
d$occasion <- as.integer(d$trial_index)

fit_nominal <- function(dat, rhs) {
  dat <- droplevels(dat)
  dat$response_category <- factor(dat$response_category)
  multgee::nomLORgee(
    formula = stats::as.formula(paste("response_category ~", rhs)),
    data = dat,
    id = dat$participant_id,
    repeated = dat$occasion,
    LORstr = "time.exch"
  )
}

# Design-covariate model and exact-age model for each task.
base_rhs <- "grade + sex + school + base_letter + centered_trial_index"
age_rhs <- "grade + exact_age_years + sex + school + base_letter + centered_trial_index"

fits_grade <- list()
fits_exact_age <- list()
for (task_name in c("lowercase_identification", "mirror", "rotation")) {
  dt <- d[d$task == task_name, , drop = FALSE]
  fits_grade[[task_name]] <- fit_nominal(dt, base_rhs)
  dta <- dt[!is.na(dt$exact_age_years), , drop = FALSE]
  fits_exact_age[[task_name]] <- fit_nominal(dta, age_rhs)
}

# Rotation sensitivity specifications.
rot <- d[d$task == "rotation" & !is.na(d$exact_age_years), , drop = FALSE]

fit_rotation_spline3 <- fit_nominal(
  rot,
  "grade + splines::bs(exact_age_years, df = 3) + sex + school + base_letter + centered_trial_index"
)
fit_rotation_spline4 <- fit_nominal(
  rot,
  "grade + splines::bs(exact_age_years, df = 4) + sex + school + base_letter + centered_trial_index"
)
fit_rotation_spline5 <- fit_nominal(
  rot,
  "grade + splines::bs(exact_age_years, df = 5) + sex + school + base_letter + centered_trial_index"
)
fit_rotation_ses <- fit_nominal(
  rot,
  "grade + exact_age_years + sex + school + base_letter + centered_trial_index + family_income + guardian_education"
)
fit_rotation_grade_sex <- fit_nominal(
  rot,
  "grade * sex + exact_age_years + school + base_letter + centered_trial_index"
)

# Grade-2 / Grade-3 common-support sensitivity used in the manuscript.
rot23 <- droplevels(rot[
  rot$grade %in% c("2", "3") & rot$exact_age_years >= 8.38 & rot$exact_age_years <= 9.50,
  , drop = FALSE
])
fit_rotation_overlap <- fit_nominal(
  rot23,
  "grade + exact_age_years + sex + school + base_letter + centered_trial_index"
)

# Error-composition analysis: correct 180-degree rotation trials are removed,
# leaving left-right versus top-bottom reflection errors.
err <- rot[rot$correct == 0 & rot$grade %in% c("2", "3"), , drop = FALSE]
err <- droplevels(err)
err$left_right_error <- as.integer(err$response_category == "left_right_reflection")
err$grade3 <- as.integer(err$grade == "3")

fit_error_linear <- geepack::geeglm(
  left_right_error ~ grade3 + exact_age_years + sex + school + base_letter + centered_trial_index,
  id = participant_id,
  data = err,
  family = stats::binomial(link = "logit"),
  corstr = "exchangeable",
  std.err = "san.se"
)

fit_error_spline3 <- geepack::geeglm(
  left_right_error ~ grade3 + splines::bs(exact_age_years, df = 3) + sex + school + base_letter + centered_trial_index,
  id = participant_id,
  data = err,
  family = stats::binomial(link = "logit"),
  corstr = "exchangeable",
  std.err = "san.se"
)

extract_grade3_or <- function(fit) {
  tab <- summary(fit)$coefficients
  beta <- unname(tab["grade3", "Estimate"])
  se <- unname(tab["grade3", "Std.err"])
  data.frame(
    beta = beta,
    robust_se = se,
    odds_ratio = exp(beta),
    ci_low = exp(beta - 1.96 * se),
    ci_high = exp(beta + 1.96 * se),
    z = beta / se,
    p_value = 2 * stats::pnorm(-abs(beta / se))
  )
}

error_results <- rbind(
  cbind(age_model = "linear", extract_grade3_or(fit_error_linear)),
  cbind(age_model = "spline_df3", extract_grade3_or(fit_error_spline3))
)

print(error_results, row.names = FALSE)

# Save fitted objects only when explicitly requested; they may contain restricted
# participant-level information and must never be committed to the public repo.
out_dir <- Sys.getenv("LETTER_ROTATION_RESTRICTED_OUTPUT", unset = "")
if (nzchar(out_dir)) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  saveRDS(
    list(
      grade = fits_grade,
      exact_age = fits_exact_age,
      rotation_spline3 = fit_rotation_spline3,
      rotation_spline4 = fit_rotation_spline4,
      rotation_spline5 = fit_rotation_spline5,
      rotation_ses = fit_rotation_ses,
      rotation_grade_sex = fit_rotation_grade_sex,
      rotation_overlap = fit_rotation_overlap,
      error_linear = fit_error_linear,
      error_spline3 = fit_error_spline3
    ),
    file.path(out_dir, "cortex_fitted_models.rds")
  )
  utils::write.csv(error_results, file.path(out_dir, "error_composition_grade3_vs_grade2.csv"), row.names = FALSE)
}
