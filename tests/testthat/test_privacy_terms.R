test_that("no unapproved school names in data", {
  files <- list.files("../../data", full.names = TRUE, pattern = "\\.csv$")
  for (f in files) {
    content <- readLines(f, warn = FALSE)
    expect_false(any(grepl("avelino", content, ignore.case = TRUE)))
    expect_false(any(grepl("virgilio", content, ignore.case = TRUE)))
    expect_false(any(grepl("andr", content, ignore.case = TRUE)))
  }
})
