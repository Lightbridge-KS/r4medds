#!/usr/bin/env Rscript

# Chapter 05 exploration sandbox
# Generates draft plots + quick findings for ggplot2 chapter writing.

options(repos = c(CRAN = "https://cloud.r-project.org"))

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

needed <- c("tidyverse", "readxl", "janitor", "ggsci", "palmerpenguins", "scales")
invisible(lapply(needed, install_if_missing))

library(tidyverse)
library(readxl)
library(janitor)
library(ggsci)
library(palmerpenguins)
library(scales)

out_plot_dir <- "_explore/plots/ch05"
out_note_dir <- "_explore/notes"
dir.create(out_plot_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(out_note_dir, recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------------
# Data prep
# ------------------------------------------------------------------
diabetes_raw <- read_csv("data/diabetes.csv", show_col_types = FALSE)
diabetes <- diabetes_raw |>
  clean_names() |>
  mutate(
    bmi_class = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi < 25 ~ "Normal",
      bmi < 30 ~ "Overweight",
      TRUE ~ "Obesity"
    ) |> factor(levels = c("Underweight", "Normal", "Overweight", "Obesity")),
    diabetes_5y = fct_relevel(diabetes_5y, "neg", "pos")
  )

# ------------------------------------------------------------------
# Plot 1: Histogram (glucose distribution)
# ------------------------------------------------------------------
p1 <- ggplot(diabetes, aes(x = glucose_mg_dl)) +
  geom_histogram(binwidth = 10, fill = "#2C7FB8", color = "white", alpha = 0.9) +
  geom_vline(xintercept = 140, linetype = "dashed", linewidth = 1, color = "#D95F02") +
  annotate("text", x = 142, y = 85, label = "140 mg/dL", hjust = 0, color = "#D95F02") +
  labs(
    title = "Distribution of Plasma Glucose in the Diabetes Dataset",
    x = "Glucose (mg/dL)",
    y = "Number of patients"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_plot_dir, "01_hist_glucose.png"), p1, width = 8.5, height = 5, dpi = 150)

# ------------------------------------------------------------------
# Plot 2: Boxplot + jitter by diabetes outcome
# ------------------------------------------------------------------
p2 <- ggplot(diabetes, aes(x = diabetes_5y, y = glucose_mg_dl, fill = diabetes_5y)) +
  geom_boxplot(alpha = 0.75, outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.25, size = 1, color = "#333333") +
  scale_fill_manual(values = c("neg" = "#4DAF4A", "pos" = "#E41A1C")) +
  labs(
    title = "Glucose by 5-Year Diabetes Outcome",
    x = "Outcome at 5 years",
    y = "Glucose (mg/dL)",
    fill = "Outcome"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_plot_dir, "02_box_glucose_by_outcome.png"), p2, width = 8.5, height = 5, dpi = 150)

# ------------------------------------------------------------------
# Plot 3: Scatter plot bmi vs glucose
# ------------------------------------------------------------------
p3 <- ggplot(diabetes, aes(x = bmi, y = glucose_mg_dl, color = diabetes_5y)) +
  geom_point(alpha = 0.65, size = 2) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1) +
  scale_color_manual(values = c("neg" = "#1B9E77", "pos" = "#D95F02")) +
  labs(
    title = "Relationship between BMI and Glucose",
    subtitle = "Colored by 5-year diabetes outcome",
    x = "Body mass index (kg/m²)",
    y = "Glucose (mg/dL)",
    color = "Outcome"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_plot_dir, "03_scatter_bmi_glucose.png"), p3, width = 8.5, height = 5, dpi = 150)

# ------------------------------------------------------------------
# Plot 4: Bar chart by BMI class and outcome
# ------------------------------------------------------------------
bmi_counts <- diabetes |>
  count(diabetes_5y, bmi_class)

p4 <- ggplot(bmi_counts, aes(x = bmi_class, y = n, fill = diabetes_5y)) +
  geom_col(position = "dodge") +
  labs(
    title = "BMI Class Distribution by 5-Year Diabetes Outcome",
    x = "BMI class",
    y = "Number of patients",
    fill = "Outcome"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

ggsave(file.path(out_plot_dir, "04_bar_bmi_class_outcome.png"), p4, width = 8.5, height = 5, dpi = 150)

# ------------------------------------------------------------------
# Plot 5: Faceted histogram by outcome
# ------------------------------------------------------------------
p5 <- ggplot(diabetes, aes(x = glucose_mg_dl)) +
  geom_histogram(binwidth = 10, fill = "#3B528B", color = "white") +
  facet_wrap(~ diabetes_5y, nrow = 1) +
  labs(
    title = "Glucose Distribution Stratified by 5-Year Outcome",
    x = "Glucose (mg/dL)",
    y = "Number of patients"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(out_plot_dir, "05_facet_hist_glucose_outcome.png"), p5, width = 9, height = 4.8, dpi = 150)

# ------------------------------------------------------------------
# Plot 6: WOW plot (penguins + ggsci)
# ------------------------------------------------------------------
p6 <- ggplot(
  drop_na(penguins, bill_length_mm, flipper_length_mm, species),
  aes(x = bill_length_mm, y = flipper_length_mm, color = species)
) +
  geom_point(alpha = 0.9, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.9) +
  scale_color_lancet() +
  labs(
    title = "Palmer Penguins: Bill Length vs Flipper Length",
    subtitle = "Styled with ggsci Lancet palette for publication-like aesthetics",
    x = "Bill length (mm)",
    y = "Flipper length (mm)",
    color = "Species",
    caption = "Data: palmerpenguins"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 11, color = "#555555"),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

ggsave(file.path(out_plot_dir, "06_wow_penguins_ggsci.png"), p6, width = 9, height = 5.4, dpi = 180)

# ------------------------------------------------------------------
# Quick findings note
# ------------------------------------------------------------------
stats_outcome <- diabetes |>
  group_by(diabetes_5y) |>
  summarise(
    n = n(),
    mean_glucose = round(mean(glucose_mg_dl, na.rm = TRUE), 1),
    median_glucose = round(median(glucose_mg_dl, na.rm = TRUE), 1),
    mean_bmi = round(mean(bmi, na.rm = TRUE), 1),
    .groups = "drop"
  )

prop_high <- diabetes |>
  mutate(high_glucose = glucose_mg_dl >= 140) |>
  group_by(diabetes_5y) |>
  summarise(prop_high = percent(mean(high_glucose, na.rm = TRUE), accuracy = 0.1), .groups = "drop")

note_lines <- c(
  "# Chapter 05 Exploration Notes",
  "",
  "Generated by: _explore/scripts/ch05_ggplot2_explore.R",
  "",
  "## Saved plots",
  "- 01_hist_glucose.png",
  "- 02_box_glucose_by_outcome.png",
  "- 03_scatter_bmi_glucose.png",
  "- 04_bar_bmi_class_outcome.png",
  "- 05_facet_hist_glucose_outcome.png",
  "- 06_wow_penguins_ggsci.png",
  "",
  "## Outcome-level numeric summary",
  paste(capture.output(print(stats_outcome)), collapse = "\n"),
  "",
  "## Proportion with glucose >= 140 mg/dL",
  paste(capture.output(print(prop_high)), collapse = "\n"),
  "",
  "## Writing notes",
  "- Clinical pattern appears coherent: positive outcome group has higher glucose central tendency.",
  "- Boxplot + jitter gives a strong beginner-friendly visual for group difference.",
  "- Faceting works well for showing distribution shift without overloading a single panel.",
  "- ggsci plot is visually strong and suitable as a near-end 'wow' demonstration."
)

writeLines(note_lines, file.path(out_note_dir, "ch05-exploration-notes.md"))

message("Exploration complete.")
message(sprintf("Plots saved to: %s", out_plot_dir))
message(sprintf("Notes saved to: %s", file.path(out_note_dir, "ch05-exploration-notes.md")))
