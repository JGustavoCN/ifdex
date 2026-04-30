# Define que esses nomes são comandos, e não nomes de arquivos ou pastas
.PHONY: install fix format lint test check pre-commit build-web build-apk clean

# Instala as dependências do Flutter E ativa o Lefthook na máquina do desenvolvedor
install:
	fvm flutter pub get
	fvm dart run lefthook install
	@echo "Dependências instaladas e Lefthook (pre-commit) ativado com sucesso!"

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

# O "Cão de Guarda" chamado pelo Lefthook no pre-commit
check: format lint test

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
