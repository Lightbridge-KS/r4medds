# R for Medical Data Analysis — Book

Quarto book teaching R for healthcare professionals. Standalone self-paced material + 1-day workshop.

## Audience & Tone

- Healthcare professionals (Doctors, Nurses, etc.)
- Support Windows, MacOS, Linux environment
- Language tone: Professional Academic Tone with some casual styling

## Structure

- `contents/chapters/` — Ch 01+ (`.qmd` files, unnumbered early chapters then Parts)
- `contents/appendix/` — Appendices A-C
- `data/` — Bundled CSV datasets (`diabetes.csv`, `heart_disease.csv`, `synthetic_notes.csv`)
- `_plan/` — Book plan and context
- `_progress/TODOS.md` — Task tracking
- `_templates/` — Chapter templates:
  - `programming-chapters.qmd` — for concept-driven chapters (e.g., Ch 03)
  - `data-analysis-chapters.qmd` — for tool/output-driven chapters (e.g., Ch 04-06)

## Key Conventions

- **Tidyverse-first**: teach `dplyr`, `ggplot2`, `tidyr`, `readr`
- **Pipe**: use native `|>` (not `%>%`)
- **Callouts**: `tip`, `note`, `warning`, `caution` (Python comparisons use collapsible `caution`)
- **Datasets**: `diabetes` (primary throughout Ch 04-06), `heart_disease` (secondary), `scurvy` (warm-up in Ch 04)
- **Global options**: set in `_quarto.yml` (`execute` + `knitr.opts_chunk`), not `_common.R`
- **Each chapter** loads its own packages via `library()` explicitly

## Pedagogical Conventions

Two templates implement these conventions:

- `_templates/programming-chapters.qmd` — concept-driven chapters (variables, types, functions)
- `_templates/data-analysis-chapters.qmd` — tool/output-driven chapters (data manipulation, visualization, statistics)

### Teach Before Use
Never use a concept the reader hasn't seen yet. If a code example requires a concept (operator, syntax, pattern), introduce it in a prior section first. Audit each section for forward-references and add brief introductions where needed.

### Incremental Complexity
Introduce the simple form first, then extend. E.g., teach `if/else` (two-way) before `if/else if/else` (multi-branch). Each form gets its own subsection with its own example before combining.

### Classify to Frame
Before diving into details, give the reader a mental model of the landscape. Use a summary table or overview to show the categories, then teach each one. E.g., classify function sources (base R / packages / user-defined) before teaching `?` and custom functions.

### Explain Syntax Explicitly
When introducing new syntax, break it down piece by piece with a bullet list explaining each component. Don't assume the reader can parse unfamiliar syntax by example alone.

### Running Example (Spiral Curriculum)
Where possible, thread a single domain-relevant example throughout the chapter. Each section applies a new concept to the same scenario, so the example grows in sophistication alongside the reader's knowledge. The example should come from the medical/clinical domain to stay relevant to the audience.

### Interpretation After Output (data analysis chapters)
After each major output (table, plot, summary), include a brief interpretation paragraph (2-3 sentences). Model the habit of reading results clinically, not just generating them.

### One Tool Per Section (data analysis chapters)
Each section introduces ONE new tool or concept. Build up within the section: basic form → add one option → full polished example. Sections progress from simple tools to complex ones across the chapter.

### Data Prep Recall (data analysis chapters)
The first data chapter (Ch 04) teaches import fully. Subsequent chapters replicate the same prep in one compact code chunk with a note: "Everything here was taught in Chapter N." This keeps chapters self-contained without re-teaching.

### Defer Advanced Syntax
When there's a concise but advanced way to do something (e.g., `across()`, lambda functions), teach the explicit beginner-friendly approach in the main text. Put the advanced shortcut in a collapsed `.callout-tip`.

## Formatting Conventions

- **Tabular information** → Quarto Markdown tables (`|` pipe syntax), not plain-text ASCII
- **Conceptual flow/diagrams** → plain-text diagrams or Mermaid (`{mermaid}`) blocks
- **Python comparisons** → `.callout-caution` with `collapse="true"` and `title="Python Comparison"`
- **Side notes / good-to-know** → `.callout-note` (collapsible when lengthy)
- **Best practices / shortcuts** → `.callout-tip`
- **Common mistakes / pitfalls** → `.callout-warning`
- **Em dash** → `---` (Quarto style)

## Authoring Workflow

- Use `_explore/` as a sandbox for chapter development:
  - `_explore/scripts/` for ad-hoc R scripts
  - `_explore/plots/` for draft figure outputs
  - `_explore/notes/` for interpretation notes and writing decisions
- For data/visualization chapters, prefer this loop:
  1. Prototype in `_explore/`
  2. Validate outputs/plots and interpretation
  3. Port refined code + prose into `contents/chapters/*.qmd`
- Keep chapter-facing code beginner-friendly and explicit. If introducing new syntax, explain it before or immediately at first use.

## Deploy

- Netlify: https://r4medds.netlify.app
- Repo: https://github.com/Lightbridge-KS/r4medds
