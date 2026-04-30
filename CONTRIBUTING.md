# Contribuindo para o IFdex

Primeiramente, obrigado por se interessar em contribuir para o nosso projeto! Nós adoramos receber contribuições e ficamos muito felizes em ter você conosco. Este documento guiará você sobre como colaborar com o IFdex, respeitando as regras do nosso repositório.

## Índice

- [Contribuindo para o IFdex](#contribuindo-para-o-ifdex)
  - [Índice](#índice)
  - [Regras do Repositório (Branch `main`)](#regras-do-repositório-branch-main)
  - [Padrão de Commits (Conventional Commits)](#padrão-de-commits-conventional-commits)
  - [Como Submeter Alterações (Pull Requests)](#como-submeter-alterações-pull-requests)
  - [Como Relatar Bugs](#como-relatar-bugs)
  - [Como Sugerir Melhorias](#como-sugerir-melhorias)
  - [Convenções de Código e Guias de Estilo](#convenções-de-código-e-guias-de-estilo)
  - [Como Obter Ajuda](#como-obter-ajuda)

## Regras do Repositório (Branch `main`)

Para garantir a estabilidade do nosso projeto (especialmente na branch `main`), habilitamos um conjunto de proteções no GitHub. Por favor, esteja ciente delas ao contribuir:

- **Deleção Restrita:** A branch `main` é protegida e não pode ser deletada.
- **Pull Requests Obrigatórios:** Todos os commits devem ser feitos em uma branch secundária e submetidos via Pull Request (PR) para a branch `main`. Commits diretos na `main` são bloqueados.
- **Aprovações (Review):** Como somos uma equipe reduzida (duas pessoas), a exigência mínima de aprovações formais no sistema é **0**. No entanto, recomendamos a revisão em pares sempre que possível para garantir a qualidade do código.
- **Regras Adicionais de PRs:**
  - **Invalidação de Aprovações:** Novas atualizações (commits) enviadas para um PR invalidarão aprovações anteriores automaticamente.
  - **Resolução de Conversas:** Todas as threads de conversas (comentários de revisão) no código devem ser resolvidas e fechadas antes que um Pull Request possa ser mergeado.
  - **Atualização Obrigatória:** A branch do seu PR deve estar totalmente atualizada com o código mais recente da `main` antes que o merge seja permitido.
- **Status Checks Obrigatórios:** O código deve passar de forma bem-sucedida nas seguintes verificações automatizadas de CI/CD antes do merge:
  - `build_and_preview`
- **Force Pushes Bloqueados:** É terminantemente proibido sobrescrever o histórico da branch `main` utilizando `git push --force`.

## Padrão de Commits (Conventional Commits)

Para mantermos o histórico do projeto limpo e rastreável, nosso repositório utiliza o padrão **Conventional Commits**. O nosso hook do Git (Lefthook) validará automaticamente a sua mensagem e **bloqueará o commit** caso ele não siga a formatação correta.

A estrutura obrigatória de um commit é:
`<tipo>: <mensagem no tempo presente e com letra minúscula>`

**Tipos Permitidos:**

- `feat`: Desenvolvimento de uma nova funcionalidade (ex: _feat: adiciona upload de PDF_).
- `fix`: Correção de um bug (ex: _fix: corrige travamento na tela inicial_).
- `docs`: Alterações exclusivas na documentação (ex: _docs: atualiza readme_).
- `style`: Mudanças de formatação que não afetam a lógica (ex: _style: formata arquivos com dart format_).
- `refactor`: Mudança no código que não adiciona feature nem corrige bug (ex: _refactor: componentiza card de certificado_).
- `test`: Adição ou correção de testes automatizados.
- `chore`: Manutenção de dependências, configuração de CI/CD ou ferramentas de build.

**Regras Vitais da Mensagem:**

1. Escreva no tempo presente e no imperativo (ex: use "adiciona" ao invés de "adicionei" ou "adicionando").
2. Não utilize ponto final (`.`) no final da mensagem do commit.
3. As mensagens devem ser claras e explicar _o que_ a mudança faz e _por que_ ela foi feita[cite: 2].

## Como Submeter Alterações (Pull Requests)

1. **Crie uma branch:** A partir da `main`, crie uma branch descritiva para a sua alteração (ex: `feature/nova-ui-certificados` ou `fix/bug-upload`).
2. **Implemente sua solução:** Faça as alterações necessárias no código.
3. **Execute os testes e linters:** Certifique-se de executar localmente os comandos obrigatórios do projeto (veja as convenções de código abaixo).
4. **Commits claros:** Faça os commits com mensagens claras, em tempo presente, explicando _o que_ a mudança faz e _por que_ ela foi feita.
5. **Abra o Pull Request:** Envie sua branch para o repositório e abra um Pull Request apontando para a `main`. Preencha a descrição do PR explicando o contexto da alteração.
6. **Integração Contínua (CI):** Aguarde a verificação `build_and_preview` passar. Caso falhe, investigue os logs, corrija os problemas e faça push de novos commits na mesma branch.
7. **Revisão:** Discuta as mudanças com a equipe. Resolva todas as sugestões e comentários.

## Como Relatar Bugs

Encontrou um erro no app? Ajude-nos a consertá-lo:

1. **Pesquise:** Antes de tudo, verifique na aba **Issues** se o problema já não foi relatado por outra pessoa.
2. **Abra uma Issue:** Se o bug for novo, abra uma Issue e adicione a label `bug`.
3. **Seja Detalhista:** No corpo da Issue, forneça o máximo de informações possível:
   - **Passos para reproduzir:** O passo-a-passo exato para chegar ao erro.
   - **Comportamento atual:** O que está acontecendo de errado.
   - **Comportamento esperado:** O que deveria acontecer na verdade.
   - **Ambiente:** Em qual dispositivo/versão o erro ocorreu (Android, Web, Versão do SO, etc.).

## Como Sugerir Melhorias

Adoramos novas ideias e feedbacks construtivos! Se você tem uma sugestão de nova funcionalidade:

1. Verifique as **Issues** para confirmar se a ideia já não está sendo discutida.
2. Abra uma nova Issue com a label `enhancement` (melhoria).
3. Descreva a funcionalidade que você deseja, focando em _qual problema ela resolve_ e justificando a sua importância.
4. Se aplicável, forneça rascunhos visuais, exemplos de uso ou links de referência.

## Convenções de Código e Guias de Estilo

Para manter nossa base de código limpa e com alto padrão de qualidade acadêmica e profissional, siga estas regras estritas:

- **Formatação:** NUNCA faça um commit sem antes executar o formatador padrão. Utilize o comando `dart format .` em toda a base afetada.
- **Análise de Código:** Seu código não pode introduzir nenhum alerta do linter. Antes do push, rode `dart analyze --fatal-infos` para garantir que tudo está validado.
- **Arquitetura (Regras Acadêmicas):**
  - Siga a limitação acadêmica do projeto: use `setState` para gerenciar estado e estruturas de array para armazenamento em memória inicial.
  - Para as listagens, é **obrigatório** o uso de `ListView.builder`.
  - Componentize interfaces (Cards, Textos, Botões) e reaproveite-os conforme documentado no projeto.

## Como Obter Ajuda

Se você tiver dúvidas sobre a arquitetura, precisar de ajuda para configurar o ambiente de desenvolvimento, ou quiser debater uma solução antes de implementar, sinta-se livre para abrir uma Issue com a label `question` ou procurar diretamente a liderança do projeto/equipe.

---

Agradecemos imensamente por dedicar seu tempo e energia para tornar o IFdex melhor!
