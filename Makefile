# Define que esses nomes são comandos, e não nomes de arquivos ou pastas
.PHONY: install fix fix-lib fix-test fix-all format format-lib format-test format-all lint lint-lib lint-test lint-all test check check-all pre-commit build-web build-apk clean use-ssh use-https


# Instala o FVM, baixa o SDK, instala dependências e ativa o Lefthook na máquina
install:
	@echo "------> 1/4 Ativando o FVM na máquina..."
	dart pub global activate fvm
	@echo "------> 2/4 Baixando a versão correta do Flutter (isolada para este projeto)..."
	fvm install
	@echo "------> 3/4 Baixando os pacotes do projeto..."
	fvm flutter pub get
	@echo "------> 4/4 Blindando os commits com lefthook..."
	npx lefthook install
	@echo "------> Sucesso! Dependências instaladas e lefthook ativado!"

# --- FORMATAÇÃO ---
# Formata apenas a pasta lib (mais rápido)
format-lib:
	fvm dart format lib

# Formata apenas a pasta test
format-test:
	fvm dart format test

# Formata o núcleo do projeto (lib e test) - Padrão de desenvolvimento
format: format-lib format-test

# Formata o projeto inteiro, incluindo pastas de plataforma (web, android, ios)
format-all:
	fvm dart format .

# --- CORREÇÕES AUTOMÁTICAS ---
# Aplica correções apenas na lib
fix-lib:
	fvm dart fix lib --apply

# Aplica correções apenas na pasta de testes
fix-test:
	fvm dart fix test --apply

# Aplica correções no núcleo do projeto (lib e test)
fix: fix-lib fix-test

# Aplica correções no projeto inteiro (raiz)
fix-all:
	fvm dart fix --apply

# --- LINTER (ANÁLISE ESTÁTICA) ---
# Analisa apenas a lib
lint-lib:
	fvm flutter analyze lib --fatal-infos

# Analisa apenas os testes
lint-test:
	fvm flutter analyze test --fatal-infos

# Analisa o núcleo do projeto (lib e test) - Padrão de desenvolvimento
lint:
	fvm flutter analyze lib test --fatal-infos

# Analisa o projeto inteiro (incluindo código de plataforma)
lint-all:
	fvm flutter analyze --fatal-infos

# --- TESTES ---
# Roda os testes unitários/widgets
test:
	fvm flutter test

# --- PIPELINES DE VERIFICAÇÃO ---
# O "Cão de Guarda" padrão (rápido e focado no código Dart principal)
check: format fix lint test

# Verificação exaustiva (utilizar antes de grandes commits ou mudanças de plataforma)
check-all: format-all fix-all lint-all test

# Comando executado pelo git hook
pre-commit: check

# Limpa o cache de build (muito útil no Flutter)
clean:
	fvm flutter clean
	fvm flutter pub get

# Builds
build-web:
	fvm flutter build web --web-renderer canvaskit

build-apk:
	fvm flutter build apk --release

# Gera os ícones nativos (iOS, Android, Web) baseados nas imagens da pasta assets/
generate-icons:
	fvm flutter pub run flutter_launcher_icons

# Alterna o repositório remoto origin para usar SSH
use-ssh:
	git remote set-url origin git@github.com:JGustavoCN/ifdex.git
	@echo "Repositorio alterado para SSH com sucesso!"
	@git remote -v

# Alterna o repositório remoto origin para usar HTTPS
use-https:
	git remote set-url origin https://github.com/JGustavoCN/ifdex.git
	@echo "Repositorio alterado para HTTPS com sucesso!"
	@git remote -v


