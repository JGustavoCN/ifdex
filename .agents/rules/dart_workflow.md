---
name: dart_workflow
trigger: always_on
description: Regras de validação de código antes da entrega (Analyze e Format).
---

Before declaring a task done:
1. Address all lints, warnings, and errors introduced or present in the modified
   files. Run `dart analyze --fatal-infos <files>` or use the MCP server.
2. Run `dart format` on the modified files. Run `dart format <files>` or use the
   MCP server.
