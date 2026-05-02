# 📄 Especificação do Projeto: IFdex (Versão 1.6)

## 1. Visão Geral do Produto

- **Nome:** IFdex (Cofre de Certificados).
- **Proposta:** Hub centralizado e privado para gestão de portfólio acadêmico, integrando dados oficiais (Sispubli) e registros manuais.
- **Ecossistema:** Composto por um aplicativo de gestão (Flutter) e um roteador de compartilhamento público (Next.js).

## 2. Estratégia de Autenticação: "Acesso Instantâneo"

Para eliminar a barreira de entrada, o IFdex utiliza o conceito de **Firebase Anonymous Auth**.

- **Fase 1 (Atual):** O app funciona de forma anônima localmente, utilizando um Array/Lista em memória para simular o estado do usuário.
- **Fase 2 (Produção):**
  - Ao abrir o app, o sistema realiza um `signInAnonymously()` em segundo plano.
  - O usuário recebe um UID provisório e todos os dados são salvos no Firestore vinculados a este ID.
  - **Conversão de Conta:** Quando o usuário decidir "Criar Conta" ou "Vincular Google", utilizamos `linkWithCredential()`. O Firebase migra automaticamente o UID anônimo para a conta oficial, mantendo todos os dados intactos.

## 3. O Modelo de Dados Unificado (Entidade: `Certificado`)

O esquema é idêntico para ambas as origens, facilitando a renderização. A diferença reside apenas nas travas de edição (identificação por `origem`).

| Campo             | Tipo          | Origem: Sispubli          | Origem: Manual                          |
| :---------------- | :------------ | :------------------------ | :-------------------------------------- |
| `id`              | String        | Hash SHA-256 (API)        | UUID v4 (Gerado)                        |
| `origem`          | Enum          | `Origem.sispubli`         | `Origem.manual`                         |
| `titulo`          | String        | **Bloqueado** (Read-only) | Editável                                |
| `ano`             | Int           | **Bloqueado** (Read-only) | Editável                                |
| `instituicao`     | String        | Fixo: "IFS"               | Editável                                |
| `tipoDescricao`   | String        | Participação/Ouvinte/etc  | Editável                                |
| `cargaHoraria`    | Int?          | **Nulo** (API não fornece)| **Opcional** (1 a 5000)                 |
| `urlDocumento`    | String?       | Link Permanente (API)     | Link Externo (Opcional)                 |
| `uploadDocumento` | `File`/`Bytes`| Nulo                      | **Opcional** (Arquivo após validações)  |
| `tags`            | List          | Editável (Metadado)       | Editável (Metadado)                     |
| `notaRelevancia`  | Int (1-5)     | Editável (Metadado)       | Editável (Metadado)                     |

> [!IMPORTANT]
> No cadastro manual, os campos `urlDocumento` e `uploadDocumento` são **mutuamente exclusivos**. O usuário deve optar por fornecer um link externo ou realizar o upload de um arquivo local.

## 4. Estratégia de Acesso a Dados (100% Online)

Para manter o aplicativo leve e preservar o armazenamento interno do dispositivo, o IFdex **não realiza o download e armazenamento local** dos arquivos PDF de forma permanente.

- Toda vez que um certificado é aberto, o app consome o stream diretamente da nuvem (Sispubli ou Firebase).
- **Trade-off:** O sistema assume a dependência de conexão com a internet para a visualização dos documentos em troca de um consumo zero de espaço em disco no smartphone.

## 5. Arquitetura de Micro-frontends e Compartilhamento

O sistema adota o padrão de **Micro-frontends** para separar a gestão privada da visualização pública, resolvendo problemas de SEO e performance.

### Fronteira A: Aplicativo Interno (Flutter)

- **Stack:** Flutter (Mobile/PWA).
- **Foco:** Gestão, edição e upload.
- **Visualização:** Renderização nativa do PDF (ex: `pdf_viewer`) diretamente do stream da API ou Storage.

### Fronteira B: Roteador Público (Next.js na Vercel)

- **Stack:** Next.js (Server-Side).
- **Função:** Interceptar acessos aos "Smart Links" (`IFdex.com/c/{id}`).
- **Comportamento Inteligente (Bot vs. Humano):**
  - **Robôs (WhatsApp/LinkedIn):** Retorna apenas HTML com **OG Tags** para gerar miniaturas (thumbnails) perfeitas nos chats.
  - **Humanos:** Atua como um visualizador VIP que mascara as URLs feias do Firebase Storage e exibe o PDF dentro da identidade visual do IFdex.

### Matriz de Roteamento Dinâmico

- **Sispubli/Storage:** O Roteador busca o PDF bruto e renderiza embutido na UI do IFdex (Mascara a URL original).
- **Terceiros (Udemy/Drive):** Redirecionamento (302) com tela de transição ("Você está sendo redirecionado...").

## 6. Regras de Segurança, Otimização e Upload

Como o sistema operará na camada gratuita do Firebase, o App Flutter aplica travas rígidas:

- **Formatos Aceitos:** Exclusivamente `.pdf`, `.jpg` ou `.png`.
- **Limite de Tamanho (Bloqueio):** Bloqueio estrito na interface para impedir o upload de qualquer arquivo que exceda **5MB**.
- **Otimização Obrigatória (Imagens):** O aplicativo Flutter deve executar a **compressão automática local** de imagens (`.jpg`/`.png`) antes de iniciar o tráfego de rede.

## 7. Requisitos para a Entrega do Eixo 1 (05/05)

Foco em UI/UX, Componentização e Validações.

**A. Validações do Formulário:**

- **Título:** Obrigatório (max 100 char).
- **Ano:** 1900 a 2026.
- **Carga Horária:** Se preenchido, entre 1 e 5000.
- **Arquivo/Link:** Validação de tipo e tamanho (5MB) ou formato de URL.

**B. Gamificação e Estado (Contador de Itens):**

Para cumprir o requisito obrigatório de **"Manipulação de Estado / Contador de itens"**:

- **Contador Dinâmico:** A tela principal exibirá o número total de certificados cadastrados, atualizando via `setState` a cada inserção ou remoção.
- **Sistema de XP:** Cada certificado adicionado = **+50 XP**; removido = **-50 XP** (com confirmação).
- **Nomenclatura de Níveis:** Nível 1 (**Calouro**), Nível 2 (**Explorador**), Nível 3 (**Especialista**).
- **Regra de Progressão:** Dificuldade **exponencial**. Cada nível exige o dobro de XP do anterior.
- **Interface:** Barra de progresso com display claro do **XP restante** e o total de certificados.

**C. Experiência do Usuário (UX) e Interface:**

- **Campos Bloqueados (Sispubli):** Origens "Read-only" iniciam como desativados (`enabled: false`). Pode-se usar estética de "texto estático" no futuro para limpeza visual, mantendo a mesma lógica.
- **Dinâmica do Formulário (Exclusão Mútua):** Se "URL" for preenchida, esconde "Upload", e vice-versa.
- **Prevenção de Erros:** Disparar **`AlertDialog`** para confirmar a intenção de exclusão de certificados.
- **Feedback de Sistema:** Uso de **`SnackBars`** para notificações de sucesso (ex: "Certificado salvo") ou erros de validação.
- **Compartilhamento Híbrido:** Utilizar o pacote **`share_plus`** para acionar a gaveta nativa, garantindo sempre a opção explícita de **"Copiar Link"** (compatibilidade Web/Mobile).

**D. Checklist de Componentes e Estrutura (Exigências Acadêmicas do Eixo 1):**

Para atender integralmente aos critérios de avaliação da disciplina, a implementação do MVP deverá obrigatoriamente conter:

1. **Estrutura de Pastas (MVC ou equivalente):** Separação clara no diretório `lib/` entre `models`, `views` (telas) e `widgets` (componentes).
2. **Listagem Otimizada:** A tela principal deverá ser renderizada obrigatoriamente utilizando a classe `ListView.builder` para performance.
3. **Navegação de Edição:** Ao clicar em um `CertificadoCard` na lista, o aplicativo deve executar um push de rota, enviando o objeto como parâmetro para uma Tela de Edição dedicada.
4. **Widgets Customizados (Componentização Estrita):**
   - `CertificadoCard`: Componente reutilizável para desenhar o item da lista.
   - `RemoveButton`: Botão ou ícone de remoção extraído para uma classe própria, respeitando a paleta de cores (ThemeData).
   - `AppText`: Componente reutilizável de texto centralizado para manter a padronização de tipografia (cor e tamanho de fonte) em todo o aplicativo.

**E. Responsividade Avançada e Adaptação PWA (Web/Mobile):**

Para garantir a melhor experiência visual e ergonômica na stack híbrida do projeto (Flutter Mobile/PWA), a tela principal (Dashboard) adota o padrão estrutural `LayoutBuilder` para renderização condicional baseada na largura (breakpoints).

1. **Separação de Estado e UI:** A camada de controle (`HomeView` - Stateful) detém a lógica de negócio e o estado em memória (Array), injetando os dados de forma unidirecional em componentes visuais estritos (`HomeMobileView` e `HomeWebView` - Stateless).
2. **Mobile View (< 900px):** Interface otimizada para toque (Scroll vertical). Cumpre estritamente o requisito obrigatório de uso da classe `ListView.builder` para garantir a performance e o *lazy loading* dos itens.
3. **Web/Desktop View (>= 900px):** Interface de Painel de Controle, adotando uma "Sidebar" lateral de navegação. Para evitar espaços vazios em telas *ultrawide*, a listagem substitui o ListView pelo `GridView.builder`.
    - *Nota Técnica:* O `GridView.builder` atende ao mesmo critério de avaliação exigido no escopo do projeto, pois compartilha a mesma engine algorítmica de reciclagem de memória e renderização sob demanda do `ListView.builder`, garantindo os 60fps sem sobrecarregar a RAM.

## 8. Roadmap Evolutivo

### Evolução da Pré-visualização (Thumbnails)

1. **Fase 1 (MVP/Eixo 1): Mock Inteligente.** Uso de cards elegantes com ícones genéricos baseados na origem (ex: Ícone IFS para Sispubli, clipe para links, pasta para arquivos). Foco em performance (60fps).
2. **Fase 2 (Client-Side): Thumbnail Local.** Geração de miniatura do PDF ocorrendo 100% no celular do usuário **ANTES** do upload, garantindo custo zero de processamento em nuvem.
3. **Fase 3 (Social): Microserviço Vercel.** Rota `/api/get-og-image` para extrair miniaturas de links de terceiros (ex: Udemy).
    - **Fallback (Graceful Degradation):** Caso o microserviço da Vercel falhe (proteções de login, cookies, etc.), o sistema retorna imediatamente para o **Mock Inteligente**.

> [!NOTE]
> **Exceção de Scraping:** Nunca tentar extrair thumbnails de URLs originadas no **Sispubli**. Para estas, o Mock Inteligente com a logo oficial da instituição será o padrão permanente na lista de visualização.

### Arquitetura de Estado (Flutter)

- **Fase 1 (Eixo 1):** Utilização de **`setState`** visando agilidade de entrega no MVP.
- **Fase 2 (Escalabilidade):** Migração preparada para gerenciadores robustos como **`Provider`** ou **`Riverpod`**.

### Persistência e Auth

- **Fase 1:** Estado em memória (Array).
- **Fase 2:** Firebase Anonymous Auth + Firestore.
- **Fase 3:** Smart Links via Next.js.

## Regras de Execução e Ambiente (CRÍTICO)

1. **Gerenciamento de Versão (FVM):** Este projeto utiliza o FVM (Flutter Version Management) travado na versão `3.41.7`.
   - **NUNCA** execute comandos genéricos como `flutter pub get`.
   - **SEMPRE** utilize o prefixo do FVM ou o Makefile.

2. **Single Source of Truth para Comandos:** O arquivo `Makefile` na raiz do projeto é a única fonte da verdade para a execução de scripts.
   - Para instalar dependências: execute `make install`
   - Para formatar, rodar linter e testes: execute `make check`
   - **NÃO** crie rotinas manuais de lint ou build. Utilize estritamente os comandos definidos no `Makefile`.

3. **Formatação e Padrões (VS Code):** As regras do `.vscode/settings.json` e `.editorconfig` devem ser respeitadas. O limite de linha do Dart é de 80 caracteres e os imports devem ser organizados (limpos) a cada alteração.

## 📝 Regras para Criação de Issues via GitHub MCP

Quando você for instruído a criar uma nova Issue neste repositório usando suas ferramentas do GitHub, você DEVE formatar o `body` (corpo em Markdown) da requisição para espelhar exatamente os nossos formulários YAML.

**Se for uma Nova Funcionalidade (Feature), o corpo do markdown DEVE conter estes cabeçalhos (H3):**

### Descrição clara do que é a feature

[Sua descrição aqui]

### Qual problema ela resolve?

[Sua justificativa aqui]

### Critérios de Aceite

- [ ] [Critério 1]
- [ ] [Critério 2]

**Se for um Relato de Bug (Bug Report), o corpo do markdown DEVE conter estes cabeçalhos (H3):**

### O que aconteceu?

[Sua descrição aqui]

### Passos para reproduzir

1. [Passo 1]
2. [Passo 2]

### Qualidade do ambiente

[Especifique o ambiente: Windows/GitBash, macOS, ou Linux]

### Comportamento esperado

[Sua descrição aqui]

### Logs de erro rodando make check ou fvm flutter run

```shell
[Insira os logs aqui]
```
