import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ifdex/features/sispubli/data/sispubli_datasource.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_import_view_model.dart';
import 'package:ifdex/features/sispubli/models/filtros_sispubli.dart';
import 'package:ifdex/shared/providers/busca_providers.dart';
import 'package:ifdex/shared/providers/ordenacao_providers.dart';
import 'package:ifdex/shared/models/ordenacao_enum.dart';

part 'sispubli_providers.g.dart';

@riverpod
class FiltroSispubliNotifier extends _$FiltroSispubliNotifier {
  @override
  FiltrosSispubli build() => const FiltrosSispubli();

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

  void limparFiltros() {
    state = const FiltrosSispubli();
  }
}

@riverpod
Set<int> anosAtivosSispubli(AnosAtivosSispubliRef ref) {
  final importStateAsync = ref.watch(sispubliImportViewModelProvider);
  if (importStateAsync.value == null) return const {};
  final dtos = importStateAsync.value!.certificadosNovos;
  final anos = dtos.map((c) => c.ano).toSet();
  final sorted = anos.toList()..sort((a, b) => b.compareTo(a));
  return sorted.toSet();
}

@riverpod
Set<String> tiposAtivosSispubli(TiposAtivosSispubliRef ref) {
  final importStateAsync = ref.watch(sispubliImportViewModelProvider);
  if (importStateAsync.value == null) return const {};
  final dtos = importStateAsync.value!.certificadosNovos;
  final tipos = dtos
      .map((c) => c.tipoDescricao.trim())
      .where((t) => t.isNotEmpty)
      .toSet();
  final sorted = tipos.toList()..sort();
  return sorted.toSet();
}

/// Provider Computado que atua como Filtro Inteligente.
/// Observa o estado do fetch da API e os dados locais do usuário,
/// retornando apenas os certificados do Sispubli que ainda não
/// foram salvos no cofre do IFdex.
@riverpod
List<SispubliCertificadoDto> certificadosSispubliDisponiveis(
  CertificadosSispubliDisponiveisRef ref,
) {
  // 1. Observa o resultado do fetch
  final importStateAsync = ref.watch(sispubliImportViewModelProvider);

  if (importStateAsync.value == null) {
    return const [];
  }

  final dtosDaApi = importStateAsync.value!.certificadosNovos;

  // 2. Observa a base de dados em tempo real
  final certificadosLocaisAsync = ref.watch(certificadosViewModelProvider);

  final idsLocais = <String>{};
  if (certificadosLocaisAsync is AsyncData) {
    for (final cert in certificadosLocaisAsync.requireValue) {
      idsLocais.add(cert.id);
    }
  }

  // 3. Aplica o filtro de deduplicação reativamente
  var lista = dtosDaApi
      .where((dto) => !idsLocais.contains(dto.idUnico))
      .toList();

  // 4. Aplica os filtros avançados Sispubli
  final filtros = ref.watch(filtroSispubliNotifierProvider);
  if (filtros.minAno != null) {
    lista = lista.where((c) => c.ano >= filtros.minAno!).toList();
  }
  if (filtros.maxAno != null) {
    lista = lista.where((c) => c.ano <= filtros.maxAno!).toList();
  }
  if (filtros.tiposSelecionados.isNotEmpty) {
    lista = lista
        .where(
          (c) => filtros.tiposSelecionados.contains(c.tipoDescricao.trim()),
        )
        .toList();
  }

  // 5. Busca Texto (Case-insensitive e Trim garantidos no Debounce)
  final query = ref.watch(buscaSispubliDebouncedProvider);
  if (query.isNotEmpty) {
    lista = lista.where((dto) {
      final titulo = dto.titulo.toLowerCase().contains(query);
      final tipo = dto.tipoDescricao.toLowerCase().contains(query);
      return titulo || tipo;
    }).toList();
  }

  // 6. Ordenação
  final ordem = ref.watch(ordenacaoSispubliStateProvider);
  lista.sort((a, b) {
    switch (ordem) {
      case OrdenacaoSispubli.anoDesc:
        return b.ano.compareTo(a.ano);
      case OrdenacaoSispubli.anoAsc:
        return a.ano.compareTo(b.ano);
      case OrdenacaoSispubli.tituloAsc:
        return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
      case OrdenacaoSispubli.tituloDesc:
        return b.titulo.toLowerCase().compareTo(a.titulo.toLowerCase());
    }
  });

  return lista;
}
