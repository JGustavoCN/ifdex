import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/sispubli/data/sispubli_datasource.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_import_view_model.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_providers.dart';
import 'package:ifdex/features/sispubli/widgets/sispubli_cpf_form.dart';
import 'package:ifdex/features/sispubli/widgets/sispubli_import_progress.dart';
import 'package:ifdex/features/sispubli/widgets/sispubli_selection_list.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/widgets/app_error_state.dart';
import 'package:ifdex/shared/widgets/app_empty_state.dart';

/// Tela de importação de certificados do Sispubli.
/// Atua apenas como Controller de View, roteando as fases visuais
/// de acordo com o estado do ViewModel e do Provider Computado.
class SispubliImportView extends ConsumerStatefulWidget {
  const SispubliImportView({super.key});

  @override
  ConsumerState<SispubliImportView> createState() => _SispubliImportViewState();
}

class _SispubliImportViewState extends ConsumerState<SispubliImportView> {
  bool _importando = false;
  int _progressoAtual = 0;
  int _progressoTotal = 0;
  ImportResult? _resultado;

  Future<void> _iniciarImportacao(
    List<SispubliCertificadoDto> selecionados,
  ) async {
    setState(() {
      _importando = true;
      _progressoAtual = 0;
      _progressoTotal = selecionados.length;
    });

    final resultado = await ref
        .read(sispubliImportViewModelProvider.notifier)
        .importarSelecionados(selecionados, (int atual, int total) {
          if (mounted) {
            setState(() {
              _progressoAtual = atual;
              _progressoTotal = total;
            });
          }
        });

    if (!mounted) return;

    setState(() {
      _importando = false;
      _resultado = resultado;
    });

    _mostrarResultado(resultado);
  }

  void _mostrarResultado(ImportResult resultado) {
    final buffer = StringBuffer();

    if (resultado.importados > 0) {
      buffer.write(
        '✅ ${resultado.importados} '
        'importado(s) com sucesso',
      );
    }
    if (resultado.semDocumento > 0) {
      if (buffer.isNotEmpty) buffer.write(' | ');
      buffer.write(
        '⚠️ ${resultado.semDocumento} '
        'sem documento',
      );
    }
    if (resultado.erros > 0) {
      if (buffer.isNotEmpty) buffer.write(' | ');
      buffer.write(
        '❌ ${resultado.erros} '
        'com erro',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(buffer.toString()),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Escuta a chamada da API (ViewModel)
    final asyncState = ref.watch(sispubliImportViewModelProvider);

    // 2. Escuta o Filtro Inteligente de Deduplicação (Provider Computado)
    final disponiveis = ref.watch(certificadosSispubliDisponiveisProvider);

    return PopScope(
      canPop: !_importando,
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            _importando ? 'Importando...' : 'Importar do IFS',
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: _importando
            ? SispubliImportProgress(
                progressoAtual: _progressoAtual,
                progressoTotal: _progressoTotal,
              )
            : _resultado != null
            ? const SizedBox.shrink()
            : asyncState.when(
                loading: () => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      AppText(
                        'Consultando Sispubli...',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                error: (Object err, StackTrace _) {
                  final vm = ref.read(sispubliImportViewModelProvider.notifier);
                  return AppErrorState(
                    message: vm.traduzirErro(err),
                    onRetry: () =>
                        ref.invalidate(sispubliImportViewModelProvider),
                  );
                },
                data: (importState) {
                  // Fase 1: Sem estado = Mostrar formulário de CPF
                  if (importState == null) {
                    return const SispubliCpfForm();
                  }

                  // Fase 2: Deduplicado = Mostrar lista (ou empty se vazio)
                  // Nota: O filtro "disponiveis" reage a adições e remoções
                  // do provider global automaticamente.
                  if (disponiveis.isEmpty) {
                    return const AppEmptyState(
                      message: 'Tudo importado!',
                      subMessage:
                          'Você já possui todos '
                          'os certificados do '
                          'Sispubli no seu cofre.',
                    );
                  }

                  return SispubliSelectionList(
                    disponiveis: disponiveis,
                    onImportar: _iniciarImportacao,
                  );
                },
              ),
      ),
    );
  }
}
