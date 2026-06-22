import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifdex/features/sispubli/data/sispubli_datasource.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_import_view_model.dart';

/// Provider Computado que atua como Filtro Inteligente.
/// Observa o estado do fetch da API e os dados locais do usuário,
/// retornando apenas os certificados do Sispubli que ainda não
/// foram salvos no cofre do IFdex.
final certificadosSispubliDisponiveisProvider =
    Provider.autoDispose<List<SispubliCertificadoDto>>((ref) {
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
      return dtosDaApi
          .where((dto) => !idsLocais.contains(dto.idUnico))
          .toList();
    });
