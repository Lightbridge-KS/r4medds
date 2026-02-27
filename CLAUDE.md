# R for Medical Data Analysis — Book

Quarto book teaching R for healthcare professionals. Standalone self-paced material + 1-day workshop.

## Audience & Tone

- Healthcare professionals (Doctors, Nurses, etc.)
- Support Windows, MacOS, Linux environment
- Language tone: Professional Academic Tone with some casual styling

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

## Pedagogical Conventions

See `_templates/programming-chapters.qmd` for a chapter template that implements these.

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

## Formatting Conventions

- **Tabular information** → Quarto Markdown tables (`|` pipe syntax), not plain-text ASCII
- **Conceptual flow/diagrams** → plain-text diagrams or Mermaid (`{mermaid}`) blocks
- **Python comparisons** → `.callout-caution` with `collapse="true"` and `title="Python Comparison"`
- **Side notes / good-to-know** → `.callout-note` (collapsible when lengthy)
- **Best practices / shortcuts** → `.callout-tip`
- **Common mistakes / pitfalls** → `.callout-warning`
- **Em dash** → `---` (Quarto style)

## Deploy

- Netlify: https://r4medds.netlify.app
- Repo: https://github.com/Lightbridge-KS/r4medds
