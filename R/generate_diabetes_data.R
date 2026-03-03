#!/usr/bin/env Rscript

# Generate teaching datasets for Chapter 04 (Data Manipulation)
# - data/diabetes.csv
# - data/diabetes.xlsx
# - data/README.md (data dictionary + provenance)

options(repos = c(CRAN = "https://cloud.r-project.org"))

ensure_cran_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing CRAN package: %s", pkg))
    install.packages(pkg)
  }
}

has_medicaldata_diabetes <- function() {
  if (!requireNamespace("medicaldata", quietly = TRUE)) {
    return(FALSE)
  }

  available <- data(package = "medicaldata")$results
  if (is.null(available) || nrow(available) == 0) {
    return(FALSE)
  }

  "diabetes" %in% available[, "Item"]
}

# 1) Ensure medicaldata is installed
ensure_cran_package("medicaldata")

# 2) Ensure diabetes dataset exists in installed version
if (!has_medicaldata_diabetes()) {
  message("'medicaldata::diabetes' not found in current installed version.")
  message("Installing development version from GitHub: higgi13425/medicaldata")

  ensure_cran_package("remotes")
  remotes::install_github("higgi13425/medicaldata", upgrade = "never", quiet = TRUE)

  if (!has_medicaldata_diabetes()) {
    stop(
      "Could not find 'diabetes' dataset in medicaldata, even after GitHub install.\n",
      "Please check internet access and retry."
    )
  }
}

# 3) Load dataset
utils::data("diabetes", package = "medicaldata", envir = environment())
if (!exists("diabetes", inherits = FALSE)) {
  stop("Failed to load dataset 'diabetes' from package 'medicaldata'.")
}

diabetes_df <- tibble::as_tibble(diabetes)

# 4) Create output directory
out_dir <- "data"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

csv_path <- file.path(out_dir, "diabetes.csv")
xlsx_path <- file.path(out_dir, "diabetes.xlsx")

# 5) Write CSV + Excel
readr::write_csv(diabetes_df, csv_path)

ensure_cran_package("writexl")
writexl::write_xlsx(list(diabetes = as.data.frame(diabetes_df)), xlsx_path)


# 7) Console report
message("\nDone.")
message(sprintf("medicaldata version: %s", as.character(utils::packageVersion("medicaldata"))))
message(sprintf("Saved: %s", csv_path))
message(sprintf("Saved: %s", xlsx_path))
message(sprintf("Dimensions: %d x %d", nrow(diabetes_df), ncol(diabetes_df)))
message(sprintf("Columns: %s", paste(names(diabetes_df), collapse = ", ")))
