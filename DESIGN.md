---
version: 1.1
name: IFdex Design System
colors:
  primary: "#355E3B"
  primary-dark: "#2A4A2F"
  primary-light: "#4C7A57"
  primary-soft: "#E6F0EA"
  secondary: "#3B5CCC"
  secondary-dark: "#2F4FB2"
  secondary-light: "#6F8AE6"
  secondary-soft: "#E8EDFF"
  background: "#F6F7F8"
  surface: "#FFFFFF"
  surface-alt: "#FAFAFA"
  border: "#E5E7EB"
  divider: "#EEF0F2"
  text-primary: "#1F2937"
  text-secondary: "#6B7280"
  text-muted: "#9CA3AF"
  text-on-primary: "#FFFFFF"
  text-on-dark: "#FFFFFF"
  success: "#16A34A"
  success-soft: "#DCFCE7"
  error: "#DC2626"
  error-soft: "#FEE2E2"
  warning: "#F59E0B"
  warning-soft: "#FEF3C7"
  info: "#2563EB"
  info-soft: "#DBEAFE"
  text-disabled: "#D1D5DB"
typography:
  headline:
    fontFamily: "Inter"
    fontWeight: 600
    fontSize: 20px
  body:
    fontFamily: "Inter"
    fontWeight: 400
    fontSize: 14px
  label:
    fontFamily: "Inter"
    fontWeight: 500
    fontSize: 12px
    letterSpacing: 0.05em
    textTransform: uppercase
rounded:
  md: 14px
  card: 18px
elevation:
  none: 0px
  soft: "0 1px 2px rgba(0,0,0,0.04)"
  overlay: "0 4px 12px rgba(0,0,0,0.08)"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.text-on-primary}"
  button-primary-hover:
    backgroundColor: "{colors.primary-light}"
  button-primary-pressed:
    backgroundColor: "{colors.primary-dark}"
  button-primary-disabled:
    backgroundColor: "#A7B0A9"
  input:
    borderColor: "{colors.border}"
    rounded: "{rounded.md}"
  input-focus:
    borderColor: "{colors.primary}"
  input-error:
    borderColor: "{colors.error}"
  input-disabled:
    borderColor: "#D1D5DB"
  card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.card}"
  card-hover:
    backgroundColor: "{colors.surface-alt}"
  card-selected:
    borderColor: "{colors.primary}"
---

# 🎨 Design System: IFdex

## Overview

O IFdex atua como um "Cofre" digital e um portfólio acadêmico. A interface deve transmitir duas sensações principais: **Segurança** e **Clareza Institucional**. A interface abraça o "Premium UI", sem ruído visual, focando no que realmente importa.

**Princípios da paleta:**

* **Confiança primeiro** → verde como base
* **Clareza extrema** → neutros bem controlados
* **Ação com moderação** → azul menos agressivo
* **Sem ruído visual** → evitar cores desnecessárias

## Colors

A paleta prioriza o contraste, a legibilidade e uma estética "enterprise".

* **Primary (`#355E3B`)**: Cor de marca institucional e CTAs. Possui variações Dark (`#2A4A2F`) para estados pressionados, Light (`#4C7A57`) para hover. A variação Soft (`#E6F0EA`) deve ser utilizada como background de item selecionado, badges e estados ativos leves.
* **Secondary (`#3B5CCC`)**: Azul refinado para links e ações secundárias. Não briga com o verde e comunica ação de forma profissional.
* **Neutrals**: Base fundamental do sistema premium.
  * Background (`#F6F7F8`): Fundo geral.
  * Surface (`#FFFFFF`): Para cards e áreas de conteúdo elevado.
  * Surface Alt (`#FAFAFA`): Variação sutil.
  * Border (`#E5E7EB`) / Divider (`#EEF0F2`): Cinzas suaves para separações limpas.
* **Text**: Cores estritas para hierarquia textual (TextPrimary, TextSecondary, TextMuted, TextDisabled).
* **Feedback**: Essencial para a integridade do sistema (Success, Error, Warning, Info).

> **🚀 Roadmap (Tokens Semânticos):**
> Hoje a paleta é baseada no nome da cor (ex: `primary`, `secondary`). Para escalar e suportar "Dark Mode" real no futuro, migraremos para tokens semânticos (ex: `action-primary`, `background-card`).

## Typography

Textos devem ser consistentes, modernos e legíveis, utilizando primariamente a fonte **Inter**.

* **Títulos (Headlines)**: Text Primary. Inter, SemiBold (600), 20px.
* **Corpo (Body)**: Text Primary. Inter, Regular (400), 14px. Para leitura prolongada.
* **Metadados (Labels)**: Text Secondary/Muted. Inter, Medium (500), 12px, geralmente uppercase para cabeçalhos de seção e tags.

## Elevation & Depth

A elevação foca no contraste entre camadas. Em vez de números abstratos ("4px"), utilizamos valores CSS reais para garantir a sutileza das sombras sem sobrecarregar a UI.

* `None`: Padrão.
* `Soft` (`0 1px 2px rgba(0,0,0,0.04)`): Hover leve e cards sutis.
* `Overlay` (`0 4px 12px rgba(0,0,0,0.08)`): Modais, dropdowns e diálogos.

## Shapes

* **Inputs/Botões**: Arredondamento suave e moderno de `14px`.
* **Cards**: Arredondamento maior de `18px`.

## Components

Os componentes são baseados em estados de interação, o que diferencia o MVP de um produto maduro:

* **Botões (Primary)**:
  * Default: `Primary`
  * Hover: `PrimaryLight`
  * Pressed: `PrimaryDark`
  * Disabled: `#A7B0A9`
* **Inputs**:
  * Default: borda `Border`
  * Focus: borda `Primary`
  * Error: borda `Error`
  * Disabled: borda `#D1D5DB`
* **Cards**:
  * Default: `Surface`
  * Hover: `SurfaceAlt`
  * Selected: borda `Primary`

## Do's and Don'ts

* **Do** usar o verde Primário para as ações principais e o azul Secundário para ações de apoio.
* **Do** garantir contraste de texto (ex: texto branco sobre fundos escuros).
* **Don't** abusar de sombras. Prefira bordas e contrastes tonais para criar profundidade.
* **Don't** utilizar cores hexadecimais *hardcoded* no código fonte do aplicativo. Consuma sempre a paleta do Design System.
* **Do** garantir que todos os textos sejam renderizados através do componente `AppText`.
