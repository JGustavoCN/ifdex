---
trigger: always_on
description: Regras de validação de código antes da entrega (Analyze e Format).
---

Before declaring a task done, you MUST validate the code using the project's Makefile (which is configured to strictly use FVM):

1. **Auto-fix:** Run `make fix` in the terminal to autonomously resolve syntax issues, add missing `const` modifiers, and clean up imports.
2. **Strict Validation:** Run `make check` in the terminal. This executes the project's strict pipeline (`fvm dart format`, `fvm flutter analyze --fatal-infos`, and `fvm flutter test`).
3. **Zero-Tolerance Loop:** The code is ONLY considered done if `make check` passes perfectly. If it fails, you must read the terminal output, manually fix the remaining lints, warnings, or errors, and run `make check` again until it succeeds. Do not bypass this step.
