# =============================================================================
# risk-quant-ml-lab — R dependencies (used by the R projects)
# -----------------------------------------------------------------------------
# How to run (from the repo root, in Terminal):
#     Rscript install_packages.R
#
# It installs only what is missing, uses pre-built binaries for Apple Silicon
# when CRAN has them, and registers R as a Jupyter kernel ("R") so the R
# notebooks open in VS Code next to the Python ones.
# =============================================================================

options(repos = c(CRAN = "https://cloud.r-project.org"))

# Prefer binaries: on Apple Silicon this avoids compiling C/Fortran code.
if (Sys.info()[["sysname"]] == "Darwin") {
  options(pkgType = "binary", install.packages.compile.from.source = "never")
}

packages <- c(
  # Jupyter integration
  "IRkernel", "languageserver",
  # data wrangling & plots
  "tidyverse", "lubridate", "scales", "patchwork", "plotly", "htmlwidgets", "readxl",
  # time series & market risk
  "quantmod", "xts", "zoo", "PerformanceAnalytics", "rugarch", "mvtnorm", "stochvol",
  # credit scoring
  "scorecard", "pROC",
  # machine learning & econometrics
  "glmnet", "ranger", "xgboost", "urca", "torch",
  # state-space models (Kalman filter)
  "dlm",
  # actuarial: claims reserving and stochastic mortality
  "ChainLadder", "StMoMo", "data.table",
  # data access
  "fredr", "httr2", "jsonlite", "dotenv",
  # SQL
  "DBI", "duckdb"
)

missing <- setdiff(packages, rownames(installed.packages()))

if (length(missing) == 0) {
  message("All R packages are already installed.")
} else {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing)
}

# torch for R needs the libtorch binaries (about 200 MB), downloaded once.
if (requireNamespace("torch", quietly = TRUE) && !torch::torch_is_installed()) torch::install_torch()

# Register the kernel for the current user (safe to run more than once).
IRkernel::installspec(name = "ir", displayname = "R", user = TRUE)

# Final check: report anything that still failed to install.
still_missing <- setdiff(packages, rownames(installed.packages()))
if (length(still_missing) > 0) {
  warning("These packages could not be installed: ",
          paste(still_missing, collapse = ", "))
} else {
  message("Done. R kernel registered as 'R' in Jupyter / VS Code.")
}
