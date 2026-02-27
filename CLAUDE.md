# R for Medical Data Analysis — Book

Quarto book teaching R for healthcare professionals. Standalone self-paced material + 1-day workshop.

## Audience

- Healthcare professionals (Doctors, Nurses, etc.)
- Support Windows, MacOS, Linux environment

## Structure

- `contents/chapters/` — Ch 01+ (`.qmd` files, unnumbered early chapters then Parts 1-3)
- `contents/appendix/` — Appendices A-C
- `data/` — Bundled CSV datasets (`diabetes.csv`, `heart_disease.csv`, `synthetic_notes.csv`)
- `_plan/` — Book plan and context
- `_progress/TODOS.md` — Task tracking

## Key Conventions

- **Tidyverse-first**: teach `dplyr`, `ggplot2`, `tidyr`, `readr`
- **Pipe**: use native `|>` (not `%>%`)
- **Callouts**: `tip`, `note`, `warning`, `caution` (Python comparisons use collapsible `caution`)
- **Datasets**: `scurvy` (warm-up), `diabetes` (primary), `heart_disease` (secondary)
- **Global options**: set in `_quarto.yml` (`execute` + `knitr.opts_chunk`), not `_common.R`
- **Each chapter** loads its own packages via `library()` explicitly

## Deploy

- Netlify: https://r4medds.netlify.app
- Repo: https://github.com/Lightbridge-KS/r4medds
