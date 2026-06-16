---
name: flutter_best_practices
trigger: always_on
description: Boas práticas oficiais de Flutter adaptadas para o escopo e exigências acadêmicas do projeto IFdex (Eixo 2).
---

# AI Rules for Flutter (IFdex — Eixo 2)

You are an expert Flutter and Dart developer. Your goal is to build beautiful, performant, and maintainable applications following modern best practices, applying MVVM architecture with Riverpod.

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
* **Lists:** ALWAYS use `ListView.builder` for performance (requisito acadêmico mantido).
* **Const:** Use `const` constructors everywhere possible to reduce widget rebuilds.
* **Build Methods:** Avoid expensive operations (e.g., parsing, network) inside the `build()` method.

## Architecture (MVVM + Riverpod)
> [!IMPORTANT]
> Estas regras refletem os requisitos do Eixo 2 da disciplina.
> Para a especificação completa (diagrama de pastas, convenções de nomenclatura, regras de dependência e plano de migração), consulte [`docs/arquitetura_spec.md`](docs/arquitetura_spec.md).

* **Padrão Arquitetural:** MVVM (Model-View-ViewModel) com organização **Feature-first**.
* **State Management:** É **OBRIGATÓRIO** o uso de **Riverpod** (`flutter_riverpod`) para estado global.
  - Use `StateNotifier` / `AsyncNotifier` / `Notifier` para ViewModels.
  - Use `ref.watch()` nos widgets para reatividade.
  - Use `ref.read()` em callbacks e ações pontuais.
  - `setState` é **permitido apenas** para estado local de UI (animações, formulários).
* **Separation of Concerns:**
  - `View` → UI pura. Sem lógica de negócio.
  - `ViewModel` → Lógica de apresentação. Orquestra repositórios.
  - `Repository` → Abstração de acesso a dados.
  - `Service/DataSource` → Implementação concreta (Firestore, HTTP).
* **Routing:** Utilizar navegação padrão do Flutter (`Navigator.push` e `Navigator.pop`) ou `go_router` se necessário.

## Data Layer
* **Firestore:** Usar `cloud_firestore` para persistência. Modelar com `toMap()`/`fromMap()`.
* **HTTP:** Usar `http` ou `dio` para chamadas à API Sispubli.
* **Async States:** SEMPRE tratar os 3 estados em telas com dados: `loading`, `data`, `error`.
  - Usar `AsyncValue.when()` do Riverpod.
  - Criar widgets padronizados: `AppLoadingState`, `AppErrorState`, `AppEmptyState`.

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
