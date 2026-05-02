# Diretrizes de UI e Design System (Component-First)

Você atua como um Engenheiro de UI focado em escalabilidade. Sempre que for solicitado a criar uma nova tela ou elemento visual, você OBRIGATORIAMENTE deve seguir este ciclo de passos:

## 1. Verificação de Reuso (Pre-flight)
Antes de criar qualquer código de interface, verifique:
- O estilo solicitado já existe no arquivo `lib/theme/app_theme.dart` (ex: `CardTheme`, `InputDecorationTheme`)? Se sim, confie no tema global e NÃO sobrescreva os estilos localmente.
- Já existe um widget na pasta `lib/widgets/` que faz isso (ex: `AppText`, `CertificadoCard`)? Se sim, reutilize-o.

## 2. Proibição de Valores Hardcoded
- **NUNCA** utilize cores hexadecimais diretas (`Color(0xFF...)`) ou `Colors.red` soltos em arquivos de tela (Views). 
- Toda e qualquer cor deve ser puxada do arquivo `AppColors` ou do `Theme.of(context)`.
- **NUNCA** estilize textos manualmente com `TextStyle` repetidos. Use OBRIGATORIAMENTE o componente `AppText` injetando os estilos via semântica.

## 3. Extração Automática de Componentes (A Regra de 2)
Se, ao construir uma tela, você perceber que uma combinação de widgets (ex: um botão com ícone específico, um card de estatística, um formato de tag) será repetida mais de uma vez na mesma tela ou tem forte potencial de reuso em outras telas:
1. NÃO mantenha o código inline na árvore principal.
2. Extraia imediatamente esse bloco para uma classe `StatelessWidget` separada.
3. Coloque esse novo widget na pasta `lib/widgets/` (ou em um subdiretório semântico, se aplicável).
4. Parametrize os dados (passe textos, ícones e callbacks pelo construtor).

**Objetivo:** Manter as classes de Tela (Views) o mais enxutas possível, contendo apenas o layout macro e a injeção de estado, delegando o desenho visual para os componentes reutilizáveis.

## 4. Conexão e Evolução do DESIGN.md
O arquivo `DESIGN.md` é a **Fonte Única da Verdade** para o estilo visual deste projeto. 
Sempre que o usuário sugerir uma alteração visual na paleta, tipografia, elevação ou formato de componente, você deve **obrigatoriamente**:
1. **Atualizar o DESIGN.md:** A mudança deve ser alterada e registrada primeiro nos tokens (bloco YAML) e nas anotações do corpo do `DESIGN.md`.
2. **Avaliar o Impacto Sistêmico:** Listar proativamente e explicar ao usuário QUAIS arquivos e componentes Flutter sofrerão impactos e exigirão refatoração (ex: "Isso alterará o `app_theme.dart` e todos os botões do app que dependem da elevação").
3. **Comparar as Mudanças:** Demonstrar de forma didática e em Markdown o diff/comparativo do "Antes e Depois" da alteração visual (o que mudou nos tokens vs o impacto na árvore de UI).
