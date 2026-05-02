# ifdex

Aplicativo de cofre de certificados gamificado

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup para Desenvolvedores Windows

Este projeto utiliza o [FVM](https://fvm.dev/) (Flutter Version Management) como centralizador de versão do Flutter, garantindo que todos os desenvolvedores usem exatamente a mesma versão do SDK. O projeto também utiliza o [Lefthook](https://github.com/evilmartians/lefthook) para automatizar verificações de código antes de cada commit (pre-commit). Usa o [Makefile](Makefile) para centralizar os comandos.

Para garantir que o ambiente funcione corretamente desde o primeiro uso, siga as configurações abaixo:

1. **Ative o Modo de Desenvolvedor do Windows:**
   Isso é obrigatório para que o FVM consiga criar os links simbólicos (symlinks) da versão do Flutter dentro do projeto sem o erro de falta de privilégios (`errno = 1314`).
   - Vá em **Configurações > Privacidade e segurança** (ou Atualização e Segurança no W10) **> Para desenvolvedores**.
   - Ative a chave **Modo de Desenvolvedor**.

2. **Adicione o Pub Cache do Dart ao `PATH`:**
   Para que seu terminal reconheça o comando `fvm` globalmente após a instalação, o Windows precisa saber onde o Dart guarda esses executáveis.
   - **Verifique se já está configurado:** Abra o PowerShell e rode o comando abaixo:

     ```powershell
     $env:PATH -split ';' | Select-String -SimpleMatch "Pub\Cache\bin"
     ```

   - Se o comando retornar um caminho (como `C:\Users\SeuUsuario\AppData\Local\Pub\Cache\bin`), o seu Windows já está configurado e **você pode pular direto para o passo 3!**
   - Caso o comando não retorne nada, adicione a variável manualmente:
     - Pressione a tecla Windows, digite **Variáveis de ambiente** e selecione **Editar as variáveis de ambiente do sistema**.
     - Clique no botão **Variáveis de Ambiente...** na parte inferior.
     - Na seção "Variáveis de usuário", encontre a variável **Path**, selecione-a e clique em **Editar**.
     - Clique em **Novo** e cole o seguinte caminho: `%LOCALAPPDATA%\Pub\Cache\bin`
     - Dê OK em todas as janelas e **feche completamente seu terminal/VS Code** para aplicar a mudança.

3. **Instale o Make:**
   Abra o PowerShell como **Administrador** e rode o comando abaixo para conseguir utilizar os atalhos do projeto:

   ```powershell
   winget install ezwinports.make
   ```

4. **Instale o Node.js (Necessário para o Lefthook):**
   O projeto utiliza o `npx` para gerenciar os hooks do Git. Certifique-se de ter o Node.js instalado na sua máquina (você pode baixar do site oficial ou rodar `winget install OpenJS.NodeJS`).

5. **Instale o Firebase CLI (Opcional, mas recomendado):**
   Como o projeto utiliza Firebase, instale as ferramentas de linha de comando globais através do NPM (rode no seu terminal):

   ```bash
   npm install -g firebase-tools
   ```

6. **Terminal Padrão e WSL:**
   - Ao abrir este projeto no VS Code, o terminal padrão será automaticamente alterado para o **Git Bash**.
   - **ATENÇÃO:** Não utilize o WSL para este projeto, pois isso dificultará a conexão com emuladores Android. Rode todos os comandos `make` diretamente no terminal do Git Bash dentro do VS Code rodando no próprio Windows.

### 🚀 Primeiros Passos

Após finalizar o setup acima e clonar o repositório, abra o projeto no VS Code e rode o comando mágico no terminal para instalar todas as dependências, baixar a versão correta do Flutter e configurar os bloqueios do Git:

```bash
make install
```

---

### Comandos Úteis

Você pode usar atalhos para não precisar digitar os comandos completos sempre:

- **`make check`**: Roda o linter, aplica correções automáticas e executa os testes (`dart format`, `dart fix`, `flutter analyze`, `flutter test`).
- **`make pre-commit`**: Executa exatamente o que o Git roda antes de salvar alterações (`format` e `check`).
- **`make build-web`**: Compila o projeto para Web.
- **`make build-apk`**: Compila o projeto para Android (APK).
- **`make clean`**: Limpa o cache do Flutter.
