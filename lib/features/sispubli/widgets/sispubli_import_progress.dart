import 'package:flutter/material.dart';

import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Fase 3: Componente isolado para exibir o progresso
/// da importação dos PDFs e salvamento em lote.
class SispubliImportProgress extends StatelessWidget {
  final int progressoAtual;
  final int progressoTotal;

  const SispubliImportProgress({
    super.key,
    required this.progressoAtual,
    required this.progressoTotal,
  });

  @override
  Widget build(BuildContext context) {
    final progresso = progressoTotal > 0
        ? progressoAtual / progressoTotal
        : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_download_outlined,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              AppText.headline('Importando...'),
              const SizedBox(height: 8),
              AppText(
                '$progressoAtual de $progressoTotal',
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progresso,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: 8),
                    AppText(
                      'Não feche esta tela.',
                      fontSize: 12,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
