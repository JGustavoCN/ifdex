install:
	fvm flutter pub get

format:
	fvm dart format lib test

lint:
	fvm flutter analyze

test:
	fvm flutter test

check: format lint test

build-web:
	fvm flutter build web --web-renderer canvaskit

build-apk:
	fvm flutter build apk --release
