# Boas Práticas do Riverpod 3 (O Caminho "Riverpod Way")

Este documento consolida as regras absolutas para o uso do Riverpod na arquitetura MVVM Feature-first do projeto. Agentes e desenvolvedores DEVEM seguir estas diretrizes ao construir ViewModels e Widgets.

## 1. Mutações Imutáveis (Proibido o InvalidateSelf para CRUD)

Ao utilizar `AsyncNotifier` ou `Notifier` gerados (`@riverpod`), as mutações de estado devem SEMPRE recriar o estado de forma imutável, utilizando os dados em memória.

❌ **Padrão Anti-Pattern (PROIBIDO):**
Fazer a alteração no repositório e então chamar `ref.invalidateSelf()` para forçar um novo `build()`. Isso causa carregamentos desnecessários e flashes na interface. *Exemplo:*

```dart
// RUIM: Força um recarregamento da rede/disco
await repository.adicionar(novo);
ref.invalidateSelf(); 
```

✅ **O "Riverpod Way" (OBRIGATÓRIO):**
Atualizar o valor local sincronicamente utilizando `AsyncData` após a persistência bem-sucedida.

```dart
await repository.adicionar(novo);

// Extrai a lista atual
final listaAtual = state.requireValue; 

// Atualiza de forma reativa e instantânea
state = AsyncData([...listaAtual, novo]);
```

## 2. Roteamento Limpo (Passagem de ID, nunca de Entidades)

Ao navegar para telas de Detalhes ou Edição, NUNCA passe objetos complexos de domínio (ex: `Certificado`) pelos argumentos de navegação do construtor ou do Router.

❌ **Anti-Pattern (PROIBIDO):**
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DetalhesView(certificado: meuCertificado), // Desatualiza fácil!
));
```

✅ **O "Riverpod Way" (OBRIGATÓRIO):**
Passe apenas o ID como parâmetro. A tela destino deve usar um *Provider Computado* (`ref.watch(certificadoPorIdProvider(id))`) para resgatar a entidade. Se for uma tela de Edição (Formulário Stateful), use `ref.read(certificadoPorIdProvider(id))` no `initState` para popular os controllers.

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DetalhesView(id: certificado.id),
));
```

## 3. Minimização de Rebuilds com `select()`

Widgets que dependem de estado global devem observar *apenas* aquilo que lhes interessa. Isso é crítico para performance.

❌ **Anti-Pattern (PROIBIDO):**
```dart
// Reconstroi toda vez que QUALQUER certificado muda
final certificados = ref.watch(certificadosViewModelProvider).value;
final total = certificados?.length ?? 0;
```

✅ **O "Riverpod Way" (OBRIGATÓRIO):**
Utilizar `.select()` para focar numa propriedade específica ou usar providers derivados focados (como um provider exclusivo de XP).

```dart
// Reconstroi APENAS quando o length mudar
final total = ref.watch(
  certificadosViewModelProvider.select((asyncList) => asyncList.value?.length ?? 0)
);
```

## 4. Priorização de Providers Computados

Toda lógica de negócio derivada (Filtros Ativos, Gamificação por XP, Contagem de Itens, Agrupamentos) NÃO deve existir dentro da função `build` dos Widgets.

Se um Widget tem um `if` ou `where` para filtrar uma lista proveniente de um Provider global, extraia isso para um Provider separado (ex: `certificadosFiltradosProvider`), tornando-o testável e reativo de forma granular.
