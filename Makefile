# Define que esses nomes são comandos, e não nomes de arquivos ou pastas
.PHONY: install fix format lint test check pre-commit build-web build-apk clean

# Instala o FVM, baixa o SDK, instala dependências e ativa o Lefthook na máquina
install:
	@echo "1/4 Ativando o FVM na máquina..."
	dart pub global activate fvm
	@echo "2/4 Baixando a versão correta do Flutter (isolada para este projeto)..."
	fvm install
	@echo "3/4 Baixando os pacotes do projeto..."
	fvm flutter pub get
	@echo "4/4 Blindando os commits com Lefthook..."
	fvm dart run lefthook install
	@echo "Sucesso! Dependências instaladas e Lefthook ativado!"

# Aplica correções automáticas (consts, sintaxe, etc) sugeridas pelo linter
fix:
	fvm dart fix --apply

# Formata o código nas pastas principais
format:
	fvm dart format lib test

# Roda o linter com tolerância zero (como exigido no CONTRIBUTING.md)
lint:
	fvm flutter analyze --fatal-infos

# Roda os testes unitários/widgets
test:
	fvm flutter test

# O "Cão de Guarda" da checagem
check: format lint test

# O comando mestre executado pelo git hook e pela IA
pre-commit: fix check

# Limpa o cache de build (muito útil no Flutter)
clean:
	fvm flutter clean
	fvm flutter pub get

# Builds
build-web:
	fvm flutter build web --web-renderer canvaskit

build-apk:
	fvm flutter build apk --release