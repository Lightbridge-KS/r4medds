#!/usr/bin/env Rscript

# Generate hd_dx dataset
# - data/hd_dx.csv
# - data/hd_dx.xlsx
#
# Source: UCI ML Repository — Heart Disease (Cleveland subset, 14 attributes)
# URL: https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data

options(repos = c(CRAN = "https://cloud.r-project.org"))

ensure_cran_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing CRAN package: %s", pkg))
    install.packages(pkg)
  }
}

# --- 1) Download from UCI ---
uci_url <- paste0(
  "https://archive.ics.uci.edu/ml/machine-learning-databases/",
  "heart-disease/processed.cleveland.data"
)

uci_col_names <- c(
  "age", "sex", "cp", "trestbps", "chol", "fbs",
  "restecg", "thalach", "exang", "oldpeak", "slope",
  "ca", "thal", "num"
)

message(sprintf("Downloading from: %s", uci_url))

heart_raw <- readr::read_csv(
  uci_url,
  col_names = uci_col_names,
  na = "?"
)

message(sprintf("Downloaded: %d x %d", nrow(heart_raw), ncol(heart_raw)))

# --- 2) Rename columns to readable snake_case ---
heart_df <- dplyr::rename(
  heart_raw,
  cp_type = cp,
  resting_bp = trestbps,
  resting_ecg = restecg,
  max_hr = thalach,
  exer_ang = exang,
  st_dep = oldpeak,
  st_slope = slope,
  fluoro_vv = ca,
  hd_dx = num
)

# --- 3) Encode categorical variables as labeled factors ---
heart_df <- dplyr::mutate(
  heart_df,
  sex = factor(sex,
    levels = c(0, 1),
    labels = c("female", "male")
  ),
  cp_type = factor(cp_type,
    levels = c(1, 2, 3, 4),
    labels = c(
      "typical_angina", "atypical_angina",
      "non_anginal", "asymptomatic"
    )
  ),
  fbs = factor(fbs,
    levels = c(0, 1),
    labels = c("no", "yes")
  ),
  resting_ecg = factor(resting_ecg,
    levels = c(0, 1, 2),
    labels = c("normal", "st_t_abnormality", "lv_hypertrophy")
  ),
  exer_ang = factor(exer_ang,
    levels = c(0, 1),
    labels = c("no", "yes")
  ),
  st_slope = factor(st_slope,
    levels = c(1, 2, 3),
    labels = c("upsloping", "flat", "downsloping")
  ),
  thal = factor(thal,
    levels = c(3, 6, 7),
    labels = c("normal", "fixed_defect", "reversible_defect")
  )
)

# --- 4) Coerce numeric columns to integer where appropriate ---
heart_df <- dplyr::mutate(
  heart_df,
  age = as.integer(age),
  resting_bp = as.integer(resting_bp),
  chol = as.integer(chol),
  max_hr = as.integer(max_hr),
  fluoro_vv = as.integer(fluoro_vv),
  hd_dx = as.integer(hd_dx)
)

# --- 5) Write outputs ---
out_dir <- "data"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

csv_path <- file.path(out_dir, "heart_disease.csv")
xlsx_path <- file.path(out_dir, "heart_disease.xlsx")

readr::write_csv(heart_df, csv_path)

ensure_cran_package("writexl")
writexl::write_xlsx(
  list(data = as.data.frame(heart_df)),
  xlsx_path
)

# --- 6) Console report ---
message("\nDone.")
message(sprintf("Source: %s", uci_url))
message(sprintf("Saved: %s", csv_path))
message(sprintf("Saved: %s", xlsx_path))
message(sprintf("Dimensions: %d x %d", nrow(heart_df), ncol(heart_df)))
message(sprintf("Columns: %s", paste(names(heart_df), collapse = ", ")))
message(sprintf("Missing values: %d total", sum(is.na(heart_df))))
