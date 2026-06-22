import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'busca_providers.g.dart';

// ==========================================
// HOME - COFRE LOCAL
// ==========================================

/// Estado global em tempo real (1:1 com a digitação do teclado)
@riverpod
class BuscaHome extends _$BuscaHome {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

/// Estado com Debounce (Atraso de 300ms) - Síncrono
@riverpod
class BuscaHomeDebounced extends _$BuscaHomeDebounced {
  Timer? _timer;

  @override
  String build() {
    // Fica escutando as mudanças do texto bruto sem re-executar o build
    ref.listen<String>(buscaHomeProvider, (previous, next) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 300), () {
        // Quando estoura, aplica trim e lowercase logo na origem para garantir a sanidade
        state = next.trim().toLowerCase();
      });
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    // Estado inicial
    return ref.read(buscaHomeProvider).trim().toLowerCase();
  }
}

// ==========================================
// SISPUBLI - IMPORTAÇÃO
// ==========================================

/// Estado global em tempo real
@riverpod
class BuscaSispubli extends _$BuscaSispubli {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

/// Estado com Debounce para o Sispubli (Atraso de 300ms)
@riverpod
class BuscaSispubliDebounced extends _$BuscaSispubliDebounced {
  Timer? _timer;

  @override
  String build() {
    ref.listen<String>(buscaSispubliProvider, (previous, next) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 300), () {
        state = next.trim().toLowerCase();
      });
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    return ref.read(buscaSispubliProvider).trim().toLowerCase();
  }
}
