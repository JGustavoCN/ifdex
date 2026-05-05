---
trigger: always_on
description: Regras de validação de código antes da entrega (Analyze e Format).
---

Before declaring a task done, you MUST validate the code using the project's Makefile (which is configured to strictly use FVM):

1. **Modular Auto-fix:** Use `make fix` to resolve issues in `lib` and `test`. For faster iterations, you can use `make fix-lib`.
2. **Standard Validation:** Run `make check` in the terminal for most tasks. This ensures `lib` and `test` are formatted, fixed, and linted correctly.
3. **Exhaustive Validation:** Run `make check-all` before major commits, when modifying platform-specific code (web, android, ios), or when explicitly asked. This scans the entire project root.
4. **Zero-Tolerance Loop:** The code is ONLY considered done if `make check` (or `make check-all`) passes perfectly. If it fails, manually fix the remaining issues and run the check again.

