import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/shared/providers/busca_providers.dart';
import 'package:ifdex/shared/providers/ordenacao_providers.dart';
import 'package:ifdex/shared/models/ordenacao_enum.dart';
import 'package:ifdex/shared/models/filtros_globais.dart';

part 'certificados_view_model.g.dart';

@riverpod
class FiltroCertificados extends _$FiltroCertificados {
  @override
  FiltrosGlobais build() => const FiltrosGlobais();

  void toggleInstituicao(String inst) {
    final newSet = Set<String>.from(state.instituicoesSelecionadas);
    if (newSet.contains(inst)) {
      newSet.remove(inst);
    } else {
      newSet.add(inst);
    }
    state = state.copyWith(instituicoesSelecionadas: newSet);
  }

  void toggleEstrela(int estrela) {
    final newSet = Set<int>.from(state.estrelasSelecionadas);
    if (newSet.contains(estrela)) {
      newSet.remove(estrela);
    } else {
      newSet.add(estrela);
    }
    state = state.copyWith(estrelasSelecionadas: newSet);
  }

  void setAno(int? min, int? max) {
    state = state.copyWith(minAno: min, maxAno: max);
  }

  void toggleTipo(String tipo) {
    final newSet = Set<String>.from(state.tiposSelecionados);
    if (newSet.contains(tipo)) {
      newSet.remove(tipo);
    } else {
      newSet.add(tipo);
    }
    state = state.copyWith(tiposSelecionados: newSet);
  }

  void toggleTag(String tag) {
    final newSet = Set<String>.from(state.tagsSelecionadas);
    if (newSet.contains(tag)) {
      newSet.remove(tag);
    } else {
      newSet.add(tag);
    }
    state = state.copyWith(tagsSelecionadas: newSet);
  }

  void setCargaHoraria(int min, int max) {
    state = state.copyWith(minCargaHoraria: min, maxCargaHoraria: max);
  }

  void setOrigem(String origem) {
    state = state.copyWith(origemSelecionada: origem);
  }

  void limparFiltros() {
    state = const FiltrosGlobais();
  }
}

@riverpod
Set<String> instituicoesAtivas(InstituicoesAtivasRef ref) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) {
    return const {};
  }

  final lista = asyncCertificados.requireValue;
  final instituicoes = <String>{};

  for (final c in lista) {
    if (c.instituicao.trim().isNotEmpty) {
      instituicoes.add(c.instituicao.trim());
    }
  }

  return instituicoes;
}

@riverpod
Set<int> anosAtivos(AnosAtivosRef ref) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) return const {};
  final lista = asyncCertificados.requireValue;
  final anos = lista.map((c) => c.ano).toSet();
  // Ordenar decrescente
  final sorted = anos.toList()..sort((a, b) => b.compareTo(a));
  return sorted.toSet();
}

@riverpod
Set<String> tiposAtivos(TiposAtivosRef ref) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) return const {};
  final lista = asyncCertificados.requireValue;
  final tipos = lista
      .map((c) => c.tipoDescricao.trim())
      .where((t) => t.isNotEmpty)
      .toSet();
  final sorted = tipos.toList()..sort();
  return sorted.toSet();
}

@riverpod
Set<String> tagsAtivas(TagsAtivasRef ref) {
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) return const {};
  final lista = asyncCertificados.requireValue;
  final tags = <String>{};
  for (final c in lista) {
    tags.addAll(c.tags.map((t) => t.trim()).where((t) => t.isNotEmpty));
  }
  final sorted = tags.toList()..sort();
  return sorted.toSet();
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

  Future<void> remover(Certificado certificado) async {
    final repository = ref.read(certificadoRepositoryProvider);
    await repository.remover(certificado);

    if (state is AsyncData) {
      final listaAtual = state.requireValue;
      final novaLista = listaAtual
          .where((c) => c.id != certificado.id)
          .toList();
      state = AsyncData(novaLista);
    }
  }
}

@riverpod
List<Certificado> certificadosFiltrados(CertificadosFiltradosRef ref) {
  // Lista Original
  final asyncCertificados = ref.watch(certificadosViewModelProvider);
  if (asyncCertificados is! AsyncData) {
    return const [];
  }
  var lista = asyncCertificados.requireValue;

  // Filtros Avançados
  final filtros = ref.watch(filtroCertificadosProvider);

  // 1. Origem
  if (filtros.origemSelecionada == 'oficial') {
    lista = lista.where((c) => c.origem == Origem.sispubli).toList();
  } else if (filtros.origemSelecionada == 'manual') {
    lista = lista.where((c) => c.origem == Origem.manual).toList();
  }

  // 2. Instituições
  if (filtros.instituicoesSelecionadas.isNotEmpty) {
    lista = lista
        .where(
          (c) =>
              filtros.instituicoesSelecionadas.contains(c.instituicao.trim()),
        )
        .toList();
  }

  // 3. Estrelas
  if (filtros.estrelasSelecionadas.isNotEmpty) {
    lista = lista
        .where((c) => filtros.estrelasSelecionadas.contains(c.notaRelevancia))
        .toList();
  }

  // 4. Carga Horária
  if (filtros.minCargaHoraria > 0 || filtros.maxCargaHoraria < 5000) {
    lista = lista.where((c) {
      final ch = c.cargaHoraria ?? 0;
      return ch >= filtros.minCargaHoraria && ch <= filtros.maxCargaHoraria;
    }).toList();
  }

  // 5. Ano
  if (filtros.minAno != null) {
    lista = lista.where((c) => c.ano >= filtros.minAno!).toList();
  }
  if (filtros.maxAno != null) {
    lista = lista.where((c) => c.ano <= filtros.maxAno!).toList();
  }

  // 6. Tipo
  if (filtros.tiposSelecionados.isNotEmpty) {
    lista = lista
        .where(
          (c) => filtros.tiposSelecionados.contains(c.tipoDescricao.trim()),
        )
        .toList();
  }

  // 7. Tags
  if (filtros.tagsSelecionadas.isNotEmpty) {
    lista = lista
        .where(
          (c) => c.tags.any((t) => filtros.tagsSelecionadas.contains(t.trim())),
        )
        .toList();
  }

  // Busca Texto (Case-insensitive e Trim garantidos na origem do Debounce)
  final query = ref.watch(buscaHomeDebouncedProvider);
  if (query.isNotEmpty) {
    lista = lista.where((c) {
      final titulo = c.titulo.toLowerCase().contains(query);
      final inst = c.instituicao.toLowerCase().contains(query);
      final tipo = c.tipoDescricao.toLowerCase().contains(query);
      final tag = c.tags.any((t) => t.toLowerCase().contains(query));

      return titulo || inst || tipo || tag;
    }).toList();
  }

  // Ordenação
  final ordem = ref.watch(ordenacaoHomeStateProvider);
  lista.sort((a, b) {
    switch (ordem) {
      case OrdenacaoHome.anoDesc:
        return b.ano.compareTo(a.ano);
      case OrdenacaoHome.anoAsc:
        return a.ano.compareTo(b.ano);
      case OrdenacaoHome.relevanciaDesc:
        return b.notaRelevancia.compareTo(a.notaRelevancia);
      case OrdenacaoHome.cargaHorariaDesc:
        final chA = a.cargaHoraria ?? 0;
        final chB = b.cargaHoraria ?? 0;
        return chB.compareTo(chA);
      case OrdenacaoHome.tituloAsc:
        return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
      case OrdenacaoHome.tituloDesc:
        return b.titulo.toLowerCase().compareTo(a.titulo.toLowerCase());
    }
  });

  // Resultado Final
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
