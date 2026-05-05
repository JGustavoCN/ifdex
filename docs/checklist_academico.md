# ✅ Checklist Acadêmico — Eixo 1 (IFdex)

> **Propósito:** Este documento mapeia **cada requisito** exigido pela Atividade Pedagógica Orientada (APO) e pela Consolidação do Eixo 1 aos arquivos e trechos de código que os implementam, permitindo verificação rápida e objetiva.
>
> **Como usar:** Para cada item, o campo **"Como verificar"** indica o caminho exato no código-fonte. Abra o arquivo referenciado e localize o trecho descrito.

---

## Parte 1: Atividade Pedagógica Orientada (APO)

A APO exige a construção de um aplicativo Flutter com formulário, listagem, edição e remoção de itens, utilizando componentes reutilizáveis e gerenciamento de estado com `setState`.

### 1.1 Estrutura de Dados em Lista/Array

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Dados armazenados em Array/Lista em memória | `lib/views/home_view.dart` — linha `List<Certificado> certificados = List.from(certificadosMock);` |

**Como verificar:** Abra `lib/views/home_view.dart` e confira a propriedade `certificados` na classe `_HomeViewState`. É uma `List<Certificado>` em memória.

---

### 1.2 Gerenciamento de Estado com `setState`

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Uso obrigatório de `setState` | `lib/views/home_view.dart` — usado em `_removerCertificado()`, `_abrirFormulario()`, `_abrirDetalhes()` e filtros |

**Como verificar:** Busque `setState` em `home_view.dart`. Há 4+ chamadas explícitas atualizando a lista e os filtros.

```bash
# Comando para verificar:
grep -n "setState" lib/views/home_view.dart
```

---

### 1.3 Contador de Itens Dinâmico (Manipulação de Estado Visível)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Contador dinâmico visível na tela | **Mobile:** `lib/widgets/xp_header.dart` — exibe `$totalCertificados certificados guardados` |
| ✅ | | **Web:** `lib/views/home_web_view.dart` — `_StatsRow` exibe o total de certificados |

**Como verificar:** Abra o app e observe o header (mobile) ou a stats row (web). Adicione/remova certificados e o número atualiza em tempo real.

---

### 1.4 Tela de Listagem com `ListView.builder`

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Uso obrigatório de `ListView.builder` | `lib/views/home_mobile_view.dart` — `ListView.builder(itemCount: ...)` dentro do `Expanded` |
| ✅ | Grid equivalente para Web | `lib/views/home_web_view.dart` — `GridView.builder(...)` na `_AreaPrincipal` |

**Como verificar:**

```bash
grep -n "ListView.builder\|GridView.builder" lib/views/home_mobile_view.dart lib/views/home_web_view.dart
```

> **Nota técnica:** O `GridView.builder` usa a mesma engine de reciclagem de memória do `ListView.builder`, atendendo ao mesmo critério de performance.

---

### 1.5 Tela de Cadastro com Formulário Validado

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Formulário com `Form` e `GlobalKey<FormState>` | `lib/views/certificado_form_view.dart` — `_formKey = GlobalKey<FormState>()` |
| ✅ | Validação de campos | Cada `TextFormField` possui `validator:` com regras específicas |

**Validações implementadas:**

| Campo | Regra | Local |
|:----- |:----- |:----- |
| Título | Obrigatório, máx 100 chars | `certificado_form_view.dart` — validator do `_tituloCtrl` |
| Ano | 1900 a ano atual | `certificado_form_view.dart` — validator do `_anoCtrl` |
| Carga Horária | Opcional, 1 a 5000 | `certificado_form_view.dart` — validator do `_cargaHorariaCtrl` |
| Tags | Máx 5 tags, 20 chars/tag | `certificado_form_view.dart` — validator do `_tagsCtrl` |
| Link | Formato URL válido | `certificado_form_view.dart` — validator do `_linkCtrl` |
| Arquivo | Máx 5MB, formatos pdf/jpg/png | `certificado_form_view.dart` — `_selecionarArquivo()` |

**Como verificar:**

```bash
grep -n "validator:" lib/views/certificado_form_view.dart
```

---

### 1.6 Edição de Itens (Navegação por Push)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Clicar em item → push para tela de edição | `lib/views/home_view.dart` — `_abrirDetalhes()` usa `Navigator.push` para `CertificadoDetailsView` |
| ✅ | Objeto passado como parâmetro de construtor | `CertificadoDetailsView(certificado: certificado, editIndex: index)` |
| ✅ | Da tela de detalhes, botão "Editar" navega para `CertificadoFormView` | `lib/views/certificado_details_view.dart` — `_navegarParaEdicao()` |

**Como verificar:**

```bash
grep -n "Navigator.push" lib/views/home_view.dart lib/views/certificado_details_view.dart
```

---

### 1.7 Remoção com `AlertDialog` de Confirmação

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | `AlertDialog` antes de deletar | `lib/widgets/remove_button.dart` — `showDialog` com `DeleteCertificateDialog` |
| ✅ | Botões "Cancelar" e "Excluir" | `DeleteCertificateDialog` — `actions:` com `TextButton` e `ElevatedButton` |

**Como verificar:** Abra `lib/widgets/remove_button.dart` e confira a classe `DeleteCertificateDialog` que estende `StatelessWidget` e retorna um `AlertDialog`.

```bash
grep -n "AlertDialog\|showDialog" lib/widgets/remove_button.dart
```

---

### 1.8 `SnackBar` de Feedback

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | SnackBar ao salvar certificado | `lib/views/home_view.dart` — `_abrirFormulario()` exibe "Certificado salvo com sucesso!" |
| ✅ | SnackBar ao remover certificado | `lib/views/home_view.dart` — `_removerCertificado()` exibe "Certificado removido." |
| ✅ | SnackBar ao atualizar certificado | `lib/views/home_view.dart` — `_abrirFormulario()` e `_abrirDetalhes()` exibem "Certificado atualizado." |
| ✅ | SnackBar de erro (upload > 5MB) | `lib/views/certificado_form_view.dart` — `_selecionarArquivo()` |

**Como verificar:**

```bash
grep -n "SnackBar" lib/views/home_view.dart lib/views/certificado_form_view.dart
```

---

### 1.9 Widgets Customizados (Componentização Reutilizável)

| Status | Componente | Arquivo | Descrição |
|:------:|:---------- |:------- |:--------- |
| ✅ | `CertificadoCard` | `lib/widgets/certificado_card.dart` | Card reutilizável com Smart Mock para a listagem |
| ✅ | `RemoveButton` | `lib/widgets/remove_button.dart` | Botão de remoção com `AlertDialog`, usa `Theme.of(context).colorScheme.error` |
| ✅ | `AppText` | `lib/widgets/app_text.dart` | Componente de texto reutilizável com tipografia padronizada (Inter) |
| ✅ | `InfoBox` | `lib/widgets/info_box.dart` | Container estilizado para campos read-only |
| ✅ | `CertificadoCover` | `lib/widgets/certificado_cover.dart` | Preview visual do certificado (formulário e detalhes) |
| ✅ | `XpHeader` | `lib/widgets/xp_header.dart` | Header de gamificação mobile |

**Como verificar:** Cada componente está em um arquivo separado na pasta `lib/widgets/`.

```bash
ls lib/widgets/
```

---

### 1.10 Estrutura de Pastas (MVC ou equivalente)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Separação clara em `models`, `views`, `widgets` | `lib/models/`, `lib/views/`, `lib/widgets/` |
| ✅ | Helpers separados | `lib/helpers/gamification.dart` |
| ✅ | Tema centralizado | `lib/theme/app_theme.dart` |

**Como verificar:**

```
lib/
├── data/              # Dados mock
├── helpers/           # Lógica de negócio (Gamificação)
├── models/            # Entidades (Certificado, Origem)
├── theme/             # Design System (AppColors, AppTheme)
├── views/             # Telas (Home, Form, Details)
├── widgets/           # Componentes reutilizáveis
└── main.dart          # Entry point
```

---

## Parte 2: Consolidação Eixo 1 — Projeto Integrador

A Consolidação exige a integração de todos os conceitos em um projeto coeso, com qualidade de UI, responsividade e boas práticas.

### 2.1 Exclusão Mútua (URL vs Upload)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | URL e Upload são mutuamente exclusivos | `lib/views/certificado_form_view.dart` — `SegmentedButton<bool>` alterna entre Link e Upload |
| ✅ | Ao selecionar um modo, o outro é limpo | `onSelectionChanged:` limpa `_arquivoSelecionado` ou `_linkCtrl` |

**Como verificar:** Busque `SegmentedButton` em `certificado_form_view.dart`.

---

### 2.2 Campos Bloqueados (Sispubli)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Título, Instituição, Ano e Tipo são read-only para Sispubli | `lib/views/certificado_form_view.dart` — renderiza `InfoBox` ao invés de `TextFormField` quando `_isSispubli` |
| ✅ | Carga Horária, Tags e Relevância são editáveis para ambas as origens | Campos sempre editáveis fora do bloco `if (_isSispubli)` |

**Como verificar:**

```bash
grep -n "_isSispubli" lib/views/certificado_form_view.dart
```

---

### 2.3 Responsividade (LayoutBuilder)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | `LayoutBuilder` para breakpoints | `lib/views/home_view.dart` — `LayoutBuilder(builder: (context, constraints) { ... })` |
| ✅ | Mobile View (< 900px) com `ListView.builder` | `lib/views/home_mobile_view.dart` |
| ✅ | Web View (>= 900px) com `GridView.builder` e Sidebar | `lib/views/home_web_view.dart` |

**Como verificar:**

```bash
grep -n "LayoutBuilder\|constraints.maxWidth" lib/views/home_view.dart
```

---

### 2.4 Gamificação (XP + Níveis)

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | +50 XP por certificado | `lib/helpers/gamification.dart` — `totalXp => totalCertificados * 50` |
| ✅ | 5 níveis com progressão exponencial (delta dobrado) | Tabela em `gamification.dart` (100→200→400→800) |
| ✅ | Barra de progresso visual | `XpHeader` (mobile) e `_XpSidebarCard` (web) com `LinearProgressIndicator` |
| ✅ | XP restante exibido | Badge de "X XP restante" no header mobile e sidebar web |

**Como verificar:** Consulte [`docs/gamificacao_spec.md`](gamificacao_spec.md) para a especificação completa.

---

### 2.5 Validação do Modelo de Domínio

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Factory validada com invariantes de negócio | `lib/models/certificado.dart` — `Certificado.criar()` |
| ✅ | 30 testes unitários cobrindo todas as regras | `test/models/certificado_test.dart` |

**Como verificar:**

```bash
make check
# Saída esperada: "All tests passed!" (30 testes)
```

---

### 2.6 Design System Centralizado

| Status | Requisito | Implementação |
|:------:|:--------- |:------------- |
| ✅ | Paleta de cores centralizada (`AppColors`) | `lib/theme/app_theme.dart` |
| ✅ | Tipografia padronizada (Google Fonts Inter) | `lib/widgets/app_text.dart` e `AppTheme.light()` |
| ✅ | ThemeData unificado | `lib/theme/app_theme.dart` — `AppTheme.light()` aplicado no `MaterialApp` |
| ✅ | Zero cores hardcoded no código fonte | Apenas `AppColors.*` é utilizado (exceção: Udemy `Color(0xFF8B5CF6)` que é específica de marca) |

**Como verificar:** Consulte [`DESIGN.md`](../DESIGN.md) para a especificação completa do Design System.

---

## Resumo de Conformidade

| Categoria | Requisitos | Atendidos | Status |
|:--------- |:----------:|:---------:|:------:|
| APO — Estrutura de Dados | 1 | 1 | ✅ |
| APO — setState | 1 | 1 | ✅ |
| APO — Contador Dinâmico | 1 | 1 | ✅ |
| APO — ListView.builder | 1 | 1 | ✅ |
| APO — Formulário Validado | 1 | 1 | ✅ |
| APO — Edição via Push | 1 | 1 | ✅ |
| APO — AlertDialog | 1 | 1 | ✅ |
| APO — SnackBar | 1 | 1 | ✅ |
| APO — Componentização | 3 | 3+ | ✅ |
| APO — Estrutura de Pastas | 1 | 1 | ✅ |
| Consolidação — Exclusão Mútua | 1 | 1 | ✅ |
| Consolidação — Campos Bloqueados | 1 | 1 | ✅ |
| Consolidação — Responsividade | 1 | 1 | ✅ |
| Consolidação — Gamificação | 1 | 1 | ✅ |
| Consolidação — Modelo Validado | 1 | 1 | ✅ |
| Consolidação — Design System | 1 | 1 | ✅ |
| **TOTAL** | **17** | **17** | **✅ 100%** |
