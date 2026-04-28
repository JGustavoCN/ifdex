---
name: flutter_best_practices
trigger: always_on
description: Boas práticas oficiais de Flutter adaptadas para o escopo e exigências acadêmicas do projeto CertiVault.
---

# AI Rules for Flutter (CertiVault Adapted)

You are an expert Flutter and Dart developer. Your goal is to build beautiful, performant, and maintainable applications following modern best practices, while strictly adhering to the project's academic limitations.

## Interaction Guidelines
* **Formatting:** ALWAYS use `dart format` to ensure consistent code formatting.
* **Fixes:** Use `dart fix` to automatically fix many common errors.
* **Linting:** Strictly follow `flutter_lints`.

## Flutter Style Guide
* **SOLID Principles:** Apply SOLID principles throughout the codebase.
* **Concise and Declarative:** Write concise, modern, technical Dart code.
* **Composition over Inheritance:** Favor composition for building complex widgets and logic.
* **Immutability:** Prefer immutable data structures. Widgets should be immutable.
* **Widgets are for UI:** Compose complex UIs from smaller, reusable widgets.

## Code Quality
* **Naming:** Avoid abbreviations. Use `PascalCase` (classes), `camelCase` (members), `snake_case` (files).
* **Conciseness:** Functions should be short (<20 lines) and single-purpose.
* **Error Handling:** Anticipate and handle potential errors. Don't let code fail silently.

## Dart Best Practices
* **Effective Dart:** Follow official guidelines.
* **Null Safety:** Write sound null-safe code. Avoid the `!` operator unless absolutely guaranteed.
* **Arrow Functions:** Use `=>` for one-line functions.

## Flutter Best Practices
* **Immutability:** Widgets are immutable. Rebuild, don't mutate.
* **Composition:** Compose smaller private widgets (`class MyWidget extends StatelessWidget`) instead of helper methods returning widgets.
* **Lists:** ALWAYS use `ListView.builder` for performance, conforming to the academic rule.
* **Const:** Use `const` constructors everywhere possible to reduce widget rebuilds.
* **Build Methods:** Avoid expensive operations (e.g., parsing, network) inside the `build()` method.

## State Management & Routing (Academic Override)
> [!IMPORTANT]
> Estas regras sobrescrevem as práticas comuns de mercado para atender aos critérios da disciplina.

* **State Management:** É **OBRIGATÓRIO** o uso exclusivo de `setState` com dados estruturados em `Array` (Lista) em memória. **PROIBIDO** o uso de bibliotecas de estado (Provider, BLoC, Riverpod, GetX) ou arquiteturas complexas (ChangeNotifier, MVVM).
* **Routing:** Utilize navegação padrão do Flutter (`Navigator.push` e `Navigator.pop`). Passagem de dados deve ocorrer por parâmetros de construtor na rota. **PROIBIDO** o uso de pacotes de roteamento como `go_router`.

## Visual Design & Theming (Premium UI)
* **Aesthetics:** The UI MUST WOW the user. Implement premium designs, leveraging smooth gradients, glassmorphism, and dynamic animations.
* **Typography:** Use modern typography (e.g., Google Fonts like Inter, Roboto, Outfit). Emphasize hierarchy with correct font weights and sizes.
* **Shadows:** Use elegant, multi-layered drop shadows to create depth.
* **Interactive Elements:** Add subtle hover effects, micro-animations, and glow effects to buttons and cards to make the interface feel alive.
* **Centralized Theme:** Use a single `ThemeData` to keep consistency. Create color schemes via `ColorScheme.fromSeed` for harmonious palettes.

## Layout Best Practices
* **Expanded / Flexible:** Use to adapt widgets to available space.
* **Wrap:** Use to prevent overflows in rows or columns.
* **LayoutBuilder:** Use for responsive layouts when needed.

## Accessibility
* **Contrast:** Ensure high readability and compliance with basic accessibility contrasts.
* **Semantics:** Apply Semantic labels to icons and buttons without explicit text.
