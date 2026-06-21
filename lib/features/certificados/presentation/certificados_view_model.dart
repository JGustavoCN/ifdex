import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

part 'certificados_view_model.g.dart';

@riverpod
class FiltroCertificados extends _$FiltroCertificados {
  @override
  String build() => 'todos';

  void setFiltro(String filtro) {
    state = filtro;
  }
}

@riverpod
class CertificadosViewModel extends _$CertificadosViewModel {
  @override
  Future<List<Certificado>> build() async {
    final repository = ref.watch(certificadoRepositoryProvider);
    return repository.listarTodos();
  }

  Future<void> adicionar(Certificado certificado, {String? fileName}) async {
    final repository = ref.read(certificadoRepositoryProvider);
    await repository.adicionar(certificado, fileName: fileName);

    if (state is AsyncData) {
      final listaAtual = state.requireValue;
      final index = listaAtual.indexWhere((c) => c.id == certificado.id);
      if (index != -1) {
        final novaLista = List<Certificado>.from(listaAtual);
        novaLista[index] = certificado;
        state = AsyncData(novaLista);
      } else {
        state = AsyncData([...listaAtual, certificado]);
      }
    }
  }

  Future<void> remover(String id) async {
    final repository = ref.read(certificadoRepositoryProvider);
    await repository.remover(id);

    if (state is AsyncData) {
      final listaAtual = state.requireValue;
      final novaLista = listaAtual.where((c) => c.id != id).toList();
      state = AsyncData(novaLista);
    }
  }
}

@riverpod
List<Certificado> certificadosFiltrados(CertificadosFiltradosRef ref) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  final filtro = ref.watch(filtroCertificadosProvider);

  if (asyncCertificados is! AsyncData) {
    return const [];
  }

  final lista = asyncCertificados.requireValue;

  if (filtro == 'oficial') {
    return lista.where((c) => c.origem == Origem.sispubli).toList();
  }
  if (filtro == 'manual') {
    return lista.where((c) => c.origem == Origem.manual).toList();
  }
  return lista;
}

@riverpod
Certificado? certificadoPorId(CertificadoPorIdRef ref, String id) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) {
    return null;
  }
  final lista = asyncCertificados.requireValue;
  try {
    return lista.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}
