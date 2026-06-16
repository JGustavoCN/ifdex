import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/widgets/certificado_cover.dart';
import 'package:ifdex/features/certificados/widgets/info_box.dart';
import 'certificado_form_view.dart';

/// Tela de visualização read-only de um [Certificado].
///
/// O botão "Editar" está sempre visível e navega para
/// o [CertificadoFormView], que aplica bloqueio parcial
/// conforme a origem.
class CertificadoDetailsView extends StatelessWidget {
  final Certificado certificado;
  final int editIndex;

  const CertificadoDetailsView({
    super.key,
    required this.certificado,
    required this.editIndex,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const AppText(
          'Detalhes do Certificado',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: isMobile
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CertificadoCover.fromCertificado(
                          certificado,
                          width: double.infinity,
                        ),
                        _Content(
                          certificado: certificado,
                          editIndex: editIndex,
                        ),
                      ],
                    )
                  : IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CertificadoCover.fromCertificado(
                            certificado,
                            width: 240,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: _Content(
                                certificado: certificado,
                                editIndex: editIndex,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Conteúdo interno ──────────────────────────────────

class _Content extends StatelessWidget {
  final Certificado certificado;
  final int editIndex;

  const _Content({required this.certificado, required this.editIndex});

  @override
  Widget build(BuildContext context) {
    final temUrl =
        certificado.urlDocumento != null &&
        certificado.urlDocumento!.isNotEmpty;
    final temUpload = certificado.uploadDocumento != null;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          InfoBox(
            title: 'TÍTULO',
            child: AppText(
              certificado.titulo,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          InfoBox(
            title: 'INSTITUIÇÃO',
            child: AppText(
              certificado.instituicao,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InfoBox(
                  title: 'TIPO',
                  child: AppText(
                    certificado.tipoDescricao,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoBox(
                  title: 'ANO',
                  child: AppText(
                    certificado.ano.toString(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppText.label(
            'RELEVÂNCIA PROFISSIONAL',
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  index < certificado.notaRelevancia
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColors.warning,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: InfoBox(
                  title: 'CARGA HORÁRIA',
                  child: AppText(
                    certificado.cargaHoraria != null
                        ? '${certificado.cargaHoraria}h'
                        : 'N/A',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoBox(
                  title: 'TAGS',
                  child: certificado.tags.isEmpty
                      ? const AppText(
                          'Nenhuma',
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: certificado.tags
                              .map(_buildTagChip)
                              .toList(),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (certificado.origem == Origem.sispubli)
            const InfoBox(
              title: 'IDENTIFICADOR DE SEGURANÇA',
              child: Row(
                children: [
                  Icon(Icons.verified, size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  AppText(
                    'SISPUBLI OFICIAL',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          _buildButtons(context, temUrl, temUpload),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, bool temUrl, bool temUpload) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Visualizar (URL → url_launcher)
        if (temUrl)
          FilledButton.icon(
            onPressed: () => _abrirUrl(context),
            icon: const Icon(Icons.open_in_new),
            label: const AppText(
              'Acessar Link',
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        // Visualizar (Bytes → placeholder)
        if (!temUrl && temUpload)
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AppText(
                    'Abrir visualizador de PDF '
                    'local (Integração na Fase 2)',
                    color: AppColors.textOnPrimary,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const AppText(
              'Visualizar Arquivo',
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        // Copiar Link (só se URL)
        if (temUrl)
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: certificado.urlDocumento!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AppText(
                    'Link copiado para a área de transferência',
                    color: AppColors.textOnPrimary,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.copy),
            label: const AppText('Copiar Link', fontWeight: FontWeight.w600),
          ),
        // Editar (sempre visível)
        FilledButton.icon(
          onPressed: () => _navegarParaEdicao(context),
          icon: const Icon(Icons.edit),
          label: const AppText(
            'Editar',
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
          style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
        ),
        // Fechar
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const AppText('Fechar', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText.label(tag, color: AppColors.primary),
    );
  }

  Future<void> _abrirUrl(BuildContext ctx) async {
    final url = certificado.urlDocumento;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: AppText(
            'Não foi possível abrir o link.',
            color: AppColors.textOnPrimary,
          ),
        ),
      );
    }
  }

  Future<void> _navegarParaEdicao(BuildContext ctx) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      ctx,
      MaterialPageRoute(
        builder: (_) =>
            CertificadoFormView(certificado: certificado, editIndex: editIndex),
      ),
    );
    if (resultado != null && ctx.mounted) {
      Navigator.pop(ctx, resultado);
    }
  }
}
