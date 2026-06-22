import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/sispubli/data/sispubli_datasource.dart';
import 'package:ifdex/features/sispubli/data/sispubli_exceptions.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';

part 'sispubli_import_view_model.g.dart';

/// Estado completo do fluxo de importação.
class SispubliImportState {
  final List<SispubliCertificadoDto> certificadosNovos;
  final String token;

  const SispubliImportState({
    required this.certificadosNovos,
    required this.token,
  });
}

/// Resultado da importação em lote.
class ImportResult {
  final int importados;
  final int semDocumento;
  final int erros;

  const ImportResult({
    required this.importados,
    required this.semDocumento,
    required this.erros,
  });
}

@riverpod
class SispubliImportViewModel extends _$SispubliImportViewModel {
  @override
  Future<SispubliImportState?> build() async => null;

  /// Fase 1: Autentica, busca certificados e deduplica.
  Future<void> buscarCertificados(String cpf) async {
    state = const AsyncLoading<SispubliImportState>();

    try {
      final datasource = ref.read(sispubliDatasourceProvider);

      // 1. Autenticar
      final token = await datasource.autenticar(cpf);

      // 2. Listar certificados da API
      final dtos = await datasource.listarCertificados(token);

      state = AsyncData<SispubliImportState>(
        SispubliImportState(certificadosNovos: dtos, token: token),
      );
    } on SispubliException catch (e) {
      state = AsyncError<SispubliImportState>(e, StackTrace.current);
    } on Exception catch (e) {
      state = AsyncError<SispubliImportState>(e, StackTrace.current);
    }
  }

  /// Fase 2: Download PDFs + persistência em lote.
  Future<ImportResult> importarSelecionados(
    List<SispubliCertificadoDto> selecionados,
    void Function(int atual, int total) onProgresso,
  ) async {
    final datasource = ref.read(sispubliDatasourceProvider);
    final repo = ref.read(certificadoRepositoryProvider);
    // Token é preservado no state
    final importState = state.value;
    if (importState == null) {
      return const ImportResult(importados: 0, semDocumento: 0, erros: 0);
    }

    var importados = 0;
    var semDocumento = 0;
    var erros = 0;

    for (var i = 0; i < selecionados.length; i++) {
      final dto = selecionados[i];

      try {
        // 1. Converter DTO → Certificado
        final cert = Certificado.criar(
          id: dto.idUnico,
          origem: Origem.sispubli,
          titulo: dto.titulo,
          ano: dto.ano,
          instituicao: 'IFS',
          tipoDescricao: dto.tipoDescricao,
          cargaHoraria: null,
          urlDocumento: null,
          tags: [],
          notaRelevancia: 1,
        );

        // 2. Tentar baixar o PDF
        if (dto.urlDownload != null && dto.urlDownload!.isNotEmpty) {
          try {
            final bytes = await datasource.baixarPdf(dto.urlDownload!);

            // 3. Upload no Supabase via repository
            cert.uploadDocumento = bytes;
            await repo.adicionar(cert, fileName: '${cert.id}.pdf');
            importados++;
          } catch (e) {
            // ignore: avoid_print
            print(
              '[SispubliImport] Erro ao baixar ou fazer upload do PDF '
              '("${dto.titulo}"): $e',
            );
            // PDF falhou — salvar só metadados
            await repo.adicionar(cert);
            semDocumento++;
          }
        } else {
          // Sem URL de download — salvar só metadados
          await repo.adicionar(cert);
          semDocumento++;
        }
      } catch (e, st) {
        // ignore: avoid_print
        print(
          '[SispubliImport] ERRO TOTAL (rejeição do certificado): '
          '["${dto.titulo}"] -> $e\n$st',
        );
        erros++;
      }

      onProgresso(i + 1, selecionados.length);
    }

    // Invalidar a lista principal para recarregar
    ref.invalidate(certificadosViewModelProvider);

    return ImportResult(
      importados: importados,
      semDocumento: semDocumento,
      erros: erros,
    );
  }

  /// Traduz exceções técnicas para mensagens de usuário.
  String traduzirErro(Object erro) {
    if (erro is SispubliCpfInvalidoException) {
      return 'O CPF informado é inválido. '
          'Verifique os dígitos.';
    }
    if (erro is SispubliNaoAutorizadoException) {
      return 'Sessão expirada. Busque novamente.';
    }
    if (erro is SispubliRateLimitException) {
      return 'Muitas tentativas. '
          'Aguarde um momento.';
    }
    if (erro is SispubliIndisponivelException) {
      return 'O Sispubli está fora do ar. '
          'Tente mais tarde.';
    }
    if (erro is SispubliTimeoutException) {
      return 'O Sispubli demorou para responder. '
          'Tente novamente.';
    }
    return 'Ocorreu um erro inesperado. '
        'Tente novamente.';
  }
}
