---
name: academic_requirements
trigger: always_on
description: Regras estritas do professor para a Consolidação Eixo 1.
---

# Regras Acadêmicas: Consolidação Eixo 1 (Projeto Integrador)

Estas regras são estritas e foram extraídas diretamente dos documentos de avaliação do professor. Elas devem ser seguidas em toda a base de código do projeto IFdex para garantir a nota máxima (10,0 pontos no total, somando a APO e a Consolidação).

## 1. Estrutura de Dados e Estado
- **Armazenamento Local:** Os dados do aplicativo devem ser obrigatoriamente armazenados e manipulados em uma estrutura de lista/array em memória.
- **Gerenciamento de Estado:** É OBRIGATÓRIO o uso de `setState` (ou a forma simples de gerenciamento ensinada na disciplina) para atualizar a interface.
- **Manipulação de Estado Visível:** O app deve demonstrar a mudança de estado na interface de forma clara (exemplo exigido: um contador de itens dinâmico na tela).

## 2. Requisitos de Telas
- **Tela de Listagem (Principal):** Deve exibir os itens cadastrados. O uso do widget `ListView.builder` é **OBRIGATÓRIO**.
- **Tela de Cadastro:** Deve possuir um formulário para inserir novos itens. O formulário deve ter **validação**.
- **Edição de Dados:** Ao clicar em um item da `ListView`, o usuário deve ser enviado para uma tela de edição.

## 3. Interações e Feedbacks (UX)
- **Remoção de Itens:** Cada item da lista deve poder ser removido pelo usuário.
- **Confirmação de Remoção:** Antes de deletar qualquer item, é obrigatório exibir um `AlertDialog` exigindo que o usuário confirme a exclusão.
- **Notificação de Sucesso:** Após realizar um cadastro com sucesso, é obrigatório exibir uma mensagem ao usuário utilizando um `SnackBar`.

## 4. Componentização Reutilizável (Arquitetura)
O código deve apresentar organização básica em arquivos. Os seguintes elementos devem, **obrigatoriamente**, ser abstraídos em componentes reutilizáveis:
- **Item da Lista:** O card/widget exibido na listagem.
- **Botão/Ícone de Remoção:** O botão de lixeira/remoção deve ser criado como um componente próprio, seguindo a paleta de cores do app.
- **Exibição de Textos:** Os textos principais devem utilizar um componente reutilizável de texto, com padronização de cor e tamanho da fonte.

## 5. Diretrizes de Ação para o Agente (Agent Instructions)
Como o assistente IA atuando neste projeto, você DEVE garantir que os requisitos acima sejam rigorosamente mantidos ao longo do tempo. Siga estas diretrizes:
- **Verificação Ativa:** Sempre que você for instruído a refatorar ou adicionar novas features, verifique se a sua solução não quebra as exigências acima (ex: não troque `ListView.builder` por `Column` ou `ListView` simples; não remova o `setState` a menos que instruído).
- **Abstração:** Sempre que você notar o uso repetitivo de estilos de texto, botões de exclusão ou cards na lista, extraia-os para componentes reutilizáveis, garantindo que o requisito de "Componentização Reutilizável" continue válido.
- **Auditoria de UX:** Sempre que criar ou modificar formulários, garanta que a validação, o `SnackBar` de sucesso e o `AlertDialog` de remoção estejam presentes no código-fonte.
- **Gerenciamento de Estado:** Não tente introduzir soluções avançadas de estado (como Riverpod, BLoC ou Provider) para cumprir as funções básicas, a menos que o usuário exija explicitamente. O requisito principal pede uso de `setState` e dados em `Array` na memória.
