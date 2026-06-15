# 🎮 Especificação de Gamificação — IFdex

> **Versão:** 1.0  
> **Última Atualização:** 2026-05-04  
> **Arquivo de Implementação:** [`lib/helpers/gamification.dart`](../lib/helpers/gamification.dart)

## 1. Propósito

O sistema de gamificação do IFdex visa motivar o usuário a construir um portfólio acadêmico robusto, oferecendo feedback visual imediato (XP, nível e barra de progresso) a cada certificado adicionado ou removido.

Além da motivação, o sistema **cumpre o requisito acadêmico obrigatório** de "Manipulação de Estado", demonstrando o uso de gerenciamento de estado (Riverpod no Eixo 2, `setState` no Eixo 1) para atualizar a interface dinamicamente.

## 2. Fórmula de XP

O XP total é **computado** (derivado), não armazenado:

```bash
totalXp = totalCertificados × 50
```

- **+50 XP** por certificado adicionado.
- **-50 XP** por certificado removido (com confirmação via `AlertDialog`).

> **Decisão de Design:** Ao computar o XP a partir da contagem do Array, eliminamos qualquer risco de dessincronização de estado. O XP nunca fica "errado".

## 3. Tabela de Progressão (Curva Exponencial)

A regra de progressão segue o princípio de **delta dobrado**: a cada transição de nível, a quantidade de XP necessária para avançar dobra em relação à anterior.

| Nível | Nome          | XP Base | XP Target | Delta (XP para subir) | Certificados no nível |
|:-----:|:------------- |--------:|----------:|----------------------:|----------------------:|
| 1     | **Calouro**   | 0       | 100       | 100                   | 2                     |
| 2     | **Explorador**| 100     | 300       | 200                   | 4                     |
| 3     | **Especialista**| 300   | 700       | 400                   | 8                     |
| 4     | **Mestre**    | 700     | 1.500     | 800                   | 16                    |
| 5     | **Lenda**     | 1.500   | ∞ (máx)   | — (nível máximo)      | —                     |

### 3.1 Visualização da Curva

```bash
Delta:  100 ──→ 200 ──→ 400 ──→ 800
         ×2      ×2      ×2
```

### 3.2 Exemplos Práticos

| Certificados | XP Total | Nível | Nome         | Progresso no nível |
|:------------:|:--------:|:-----:|:------------ |:------------------:|
| 0            | 0        | 1     | Calouro      | 0%                 |
| 1            | 50       | 1     | Calouro      | 50%                |
| 2            | 100      | 2     | Explorador   | 0%                 |
| 6            | 300      | 3     | Especialista | 0%                 |
| 10           | 500      | 3     | Especialista | 50%                |
| 14           | 700      | 4     | Mestre       | 0%                 |
| 22           | 1.100    | 4     | Mestre       | 50%                |
| 30           | 1.500    | 5     | Lenda        | 100% (máximo)      |

## 4. Fórmula de Progresso Dentro do Nível

```bash
progressoPercent = (totalXp - xpBase) / (xpTarget - xpBase)
```

- Clamped entre `0.0` e `1.0`.
- No nível 5 (Lenda), retorna `1.0` (barra cheia).

## 5. Interface

O sistema de XP é exibido em dois contextos diferentes:

### 5.1 Mobile (`XpHeader`)

Header gradiente no topo da tela principal, contendo:

- Logo + branding "IFdex"
- Nível atual (ex: `LVL 2 • EXPLORADOR`)
- XP total em destaque (ex: `300 XP`)
- Badge de XP restante (ex: `400 XP restante`)
- Barra de progresso (`LinearProgressIndicator`)
- Contagem de certificados (ex: `6 certificados guardados`)

### 5.2 Web/Desktop (`_XpSidebarCard` + `_XpStatCard`)

- **Sidebar:** Card compacto com nível, XP, barra de progresso e XP restante.
- **Stats Row:** Card gradiente com o nome do nível e XP total.

## 6. Rastreabilidade

| Componente | Arquivo | Função |
|:---------- |:------- |:------ |
| Lógica de cálculo | `lib/helpers/gamification.dart` | Classe `Gamification` |
| Header Mobile | `lib/widgets/xp_header.dart` | Widget `XpHeader` |
| Sidebar Web | `lib/views/home_web_view.dart` | Widgets `_XpSidebarCard`, `_XpStatCard` |
| Estado (Riverpod) | `lib/features/certificados/presentation/` | ViewModel/Notifier |
