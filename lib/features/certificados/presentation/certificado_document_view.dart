import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/utils/file_type_detector.dart';

/// Tela dedicada à visualização em tela cheia de Documentos (PDF, JPG, PNG).
/// Carrega o arquivo a partir dos bytes armazenados em memória e verifica sua assinatura real.
class CertificadoDocumentView extends StatelessWidget {
  final String titulo;
  final Uint8List documentBytes;

  const CertificadoDocumentView({
    super.key,
    required this.titulo,
    required this.documentBytes,
  });

  @override
  Widget build(BuildContext context) {
    final fileType = FileTypeDetector.detect(documentBytes);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: AppText(
          titulo,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _buildBody(fileType),
    );
  }

  Widget _buildBody(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return PdfViewer.data(
          documentBytes,
          sourceName: titulo,
          params: PdfViewerParams(
            backgroundColor: AppColors.background,
            loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },
            errorBannerBuilder: (context, error, stackTrace, documentRef) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      'Falha ao renderizar o documento PDF.\n'
                      'Tamanho: ${documentBytes.length} bytes\n'
                      'Erro interno: $error',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );

      case DocumentType.jpeg:
      case DocumentType.png:
        return Center(
          child: InteractiveViewer(
            child: Image.memory(
              documentBytes,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: AppColors.error,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      AppText(
                        'Falha ao renderizar a imagem.\nO arquivo pode estar corrompido.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

      case DocumentType.unknown:
        // Exibe erro educado se for arquivo corrompido ou página HTML do Sispubli
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const AppText(
                  'Arquivo Corrompido ou Inválido',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const AppText(
                  'A API de importação (Sispubli) retornou dados inválidos ou uma página de erro em vez do documento real.\n\n'
                  'Por favor, exclua este certificado e tente importá-lo novamente mais tarde.',
                  textAlign: TextAlign.center,
                  color: AppColors.textSecondary,
                  maxLines: 5,
                ),
                const SizedBox(height: 32),
                AppText(
                  'Tamanho recebido: ${documentBytes.length} bytes\n'
                  'Os primeiros bytes não correspondem a PDF, JPG ou PNG.',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
    }
  }
}
