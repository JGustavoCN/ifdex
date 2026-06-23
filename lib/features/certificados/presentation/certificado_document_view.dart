import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/utils/file_type_detector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, _getExtensao(fileType)),
            Expanded(child: _buildBody(fileType)),
          ],
        ),
      ),
    );
  }

  String _getExtensao(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return '.pdf';
      case DocumentType.jpeg:
        return '.jpg';
      case DocumentType.png:
        return '.png';
      case DocumentType.unknown:
        return '.bin';
    }
  }

  Widget _buildTopBar(BuildContext context, String extensao) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000), // 4% opacity (soft elevation)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Voltar',
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/logo_transparent.png',
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              titulo,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => _compartilharArquivo(context, extensao),
            icon: const Icon(
              Icons.share_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            tooltip: 'Compartilhar Arquivo',
          ),
          const SizedBox(width: 4),
          ElevatedButton.icon(
            onPressed: () => _baixarArquivoFisico(context, extensao),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.download_rounded, size: 20),
            label: const AppText(
              'Baixar',
              fontWeight: FontWeight.w600,
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _compartilharArquivo(
    BuildContext context,
    String extensao,
  ) async {
    try {
      final String nomeSaneado = titulo
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s-]'), '')
          .trim()
          .replaceAll(' ', '_');
      final String nomeArquivo =
          '${nomeSaneado.isEmpty ? "documento" : nomeSaneado}$extensao';

      final xFile = XFile.fromData(
        documentBytes,
        name: nomeArquivo,
        mimeType: _getMimeType(extensao),
      );

      // ignore: deprecated_member_use
      await Share.shareXFiles([xFile], text: 'Documento IFdex: $titulo');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
              'Erro ao compartilhar: $e',
              color: AppColors.surface,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _baixarArquivoFisico(
    BuildContext context,
    String extensao,
  ) async {
    try {
      final String nomeSaneado = titulo
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s-]'), '')
          .trim()
          .replaceAll(' ', '_');
      final String nomeBase = nomeSaneado.isEmpty
          ? 'documento_ifdex'
          : nomeSaneado;

      MimeType mimeType;
      switch (extensao) {
        case '.pdf':
          mimeType = MimeType.pdf;
          break;
        case '.png':
          mimeType = MimeType.png;
          break;
        case '.jpg':
        case '.jpeg':
          mimeType = MimeType.jpeg;
          break;
        default:
          mimeType = MimeType.other;
      }

      final extLimpa = extensao.replaceAll('.', '');

      await FileSaver.instance.saveFile(
        name: '$nomeBase.$extLimpa',
        bytes: documentBytes,
        fileExtension: extLimpa,
        mimeType: mimeType,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: AppText(
              'Download iniciado com sucesso.',
              color: AppColors.surface,
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText('Erro ao baixar: $e', color: AppColors.surface),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getMimeType(String extensao) {
    switch (extensao) {
      case '.pdf':
        return 'application/pdf';
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
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
