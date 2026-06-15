---
name: academic_requirements
trigger: always_on
description: Regras estritas do professor para a Consolidação Eixo 2.
---

# Regras Acadêmicas: Consolidação Eixo 2 (Projeto Integrador)

Estas regras são estritas e foram extraídas diretamente do documento de avaliação do professor para o **Eixo 2**. Elas devem ser seguidas em toda a base de código do projeto IFdex para garantir a nota máxima.

> [!IMPORTANT]
> O Eixo 2 **inverte** várias regras do Eixo 1. O que era proibido (Riverpod, MVVM) agora é **obrigatório**. O que era obrigatório (setState como único gerenciador) agora é **insuficiente**.

## 1. Arquitetura em Camadas
- **Obrigatório:** O projeto deve adotar uma arquitetura com **separação clara de responsabilidades** (MVVM com Riverpod).
- **Proibido:** Concentrar toda a lógica diretamente nas telas/views.
- **Camadas:** View → ViewModel → Repository → DataSource.
- **Organização:** Feature-first com pastas `data/`, `models/`, `presentation/`, `widgets/` por feature.

## 2. Gerenciamento de Estado Global
- **Obrigatório:** Uso de **Riverpod** (`flutter_riverpod`) como gerenciador de estado global.
- **`setState`:** Permitido **apenas** para estado local de UI (animações, controllers de texto, formulários).
- **Proibido:** Usar `setState` como único mecanismo de gerenciamento de estado da aplicação.
- O estado deve ser utilizado de forma coerente: listagens, filtros, carregamento de dados, cadastro, remoção, edição.

## 3. Dados Reais (Requisições Externas + Dados Estruturados)
O aplicativo deve implementar **ambas** as alternativas:
- **Opção A (Requisições Externas):** Chamadas HTTP para a API Sispubli com tratamento de loading, sucesso e erro.
- **Opção B (Dados Estruturados):** Persistência com Cloud Firestore (CRUD completo).

## 4. Organização em Pastas
- Separação obrigatória em camadas: `features/`, `shared/`, `app/`.
- Cada feature com suas próprias pastas internas.
- Nomenclatura clara e compreensível.

## 5. Interface Funcional e Coerente
- A interface deve permitir: consultar, cadastrar, remover, editar, filtrar e visualizar dados.
- Manter todos os requisitos visuais do Eixo 1: `AlertDialog`, `SnackBar`, `ListView.builder`, componentização.
- Tratamento visual de estados assíncronos (loading shimmer, error widget, empty state).

## 6. Complexidade Compatível
Serão avaliados:
- Quantidade e qualidade dos fluxos implementados.
- Número de telas úteis.
- Integração entre telas.
- Uso adequado da arquitetura.
- Uso real do gerenciamento de estado.
- Tratamento de carregamento, erro ou dados vazios.
- Persistência local ou comunicação externa funcionando corretamente.

## 7. Diretrizes de Ação para o Agente (Agent Instructions)
Como o assistente IA atuando neste projeto, você DEVE:
- **Usar Riverpod** para todo estado de negócio. Criar `StateNotifier`, `AsyncNotifier` ou `Notifier` conforme o caso.
- **Respeitar MVVM:** Lógica de negócio nos ViewModels/Notifiers, acesso a dados nos Repositories.
- **Tratar estados assíncronos:** Usar `AsyncValue.when()` para loading/data/error em toda tela que consome dados.
- **Manter componentização:** CertificadoCard, RemoveButton, AppText continuam obrigatórios.
- **Manter ListView.builder:** Continua obrigatório para listagens.
- **Manter AlertDialog + SnackBar:** Continuam obrigatórios para remoção e feedback.
