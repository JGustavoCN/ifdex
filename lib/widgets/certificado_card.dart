import 'package:flutter/material.dart';

import '../models/certificado.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';
import 'remove_button.dart';

/// Card reutilizável para exibir um [Certificado] dentro
/// de um `ListView.builder`.
///
/// Utiliza o padrão "Smart Mock" para determinar a identidade
/// visual (cor, ícone, tag) com base na origem e instituição
/// do certificado, evitando renderização real de PDFs ou imagens.
class CertificadoCard extends StatelessWidget {
  final Certificado certificado;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const CertificadoCard({
    super.key,
    required this.certificado,
    required this.onTap,
    required this.onRemove,
  });

  /// O "Cérebro" que define a paleta de cores e ícones do Mock.
  ///
  /// Retorna um [_IdentidadeVisual] baseado em 4 regras:
  /// 1. Sispubli → Verde institucional
  /// 2. AWS/Amazon → Laranja cloud
  /// 3. Udemy → Roxo plataforma
  /// 4. Manual genérico → Azul secundário
  _IdentidadeVisual _getIdentidadeVisual() {
    if (certificado.origem == Origem.sispubli) {
      return const _IdentidadeVisual(
        icon: Icons.account_balance,
        color: AppColors.primary,
        tagText: 'OFICIAL IFS',
      );
    }

    final inst = certificado.instituicao.toLowerCase();

    if (inst.contains('aws') || inst.contains('amazon')) {
      return const _IdentidadeVisual(
        icon: Icons.cloud_outlined,
        color: AppColors.warning,
        tagText: 'AWS CLOUD',
      );
    }

    if (inst.contains('udemy')) {
      return const _IdentidadeVisual(
        icon: Icons.play_circle_outline,
        color: Color(0xFF8B5CF6),
        tagText: 'UDEMY',
      );
    }

    final bool temLink =
        certificado.urlDocumento != null &&
        certificado.urlDocumento!.isNotEmpty;

    return _IdentidadeVisual(
      icon: temLink ? Icons.link : Icons.folder_open_outlined,
      color: AppColors.secondary,
      tagText: 'MANUAL',
    );
  }

  @override
  Widget build(BuildContext context) {
    final visual = _getIdentidadeVisual();

    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              _PreviewArea(
                visual: visual,
                certificado: certificado,
                onRemove: onRemove,
              ),
              _MetadadosArea(visual: visual, certificado: certificado),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Área 1: Preview Visual Superior ────────────────────────

class _PreviewArea extends StatelessWidget {
  final _IdentidadeVisual visual;
  final Certificado certificado;
  final VoidCallback onRemove;

  const _PreviewArea({
    required this.visual,
    required this.certificado,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Fundo em degradê inteligente
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  visual.color.withValues(alpha: 0.15),
                  visual.color.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(visual.icon, size: 72, color: visual.color),
              ),
            ),
          ),

          // Badge superior esquerda
          Positioned(top: 12, left: 12, child: _OrigemBadge(visual: visual)),

          // Botão de remoção (canto superior direito)
          Positioned(
            top: 4,
            right: 4,
            child: RemoveButton(
              certificado: certificado,
              onConfirmDelete: onRemove,
            ),
          ),

          // "Falsa folha de documento" emergindo da base
          const Positioned(
            bottom: -10,
            left: 20,
            right: 20,
            child: _FakeDocumentSheet(),
          ),
        ],
      ),
    );
  }
}

// ── Badge de Origem ────────────────────────────────────────

class _OrigemBadge extends StatelessWidget {
  final _IdentidadeVisual visual;

  const _OrigemBadge({required this.visual});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: visual.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText.label(
        visual.tagText,
        color: visual.color,
        letterSpacing: 1,
      ),
    );
  }
}

// ── Folha Falsa de Documento ───────────────────────────────

class _FakeDocumentSheet extends StatelessWidget {
  const _FakeDocumentSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Área 2: Metadados Inferior ─────────────────────────────

class _MetadadosArea extends StatelessWidget {
  final _IdentidadeVisual visual;
  final Certificado certificado;

  const _MetadadosArea({required this.visual, required this.certificado});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          AppText(
            certificado.titulo,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            height: 1.2,
          ),
          const SizedBox(height: 6),

          // Instituição • Ano
          Row(
            children: [
              Icon(visual.icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: AppText.label(
                  '${certificado.instituicao} • '
                  '${certificado.ano}',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tipo + Estrelas de relevância
          Row(
            children: [
              _TipoTag(tipoDescricao: certificado.tipoDescricao),
              const Spacer(),
              if (certificado.notaRelevancia > 0)
                _RelevanciaStars(nota: certificado.notaRelevancia),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tag de Tipo de Descrição ───────────────────────────────

class _TipoTag extends StatelessWidget {
  final String tipoDescricao;

  const _TipoTag({required this.tipoDescricao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText.label(
        tipoDescricao.toUpperCase(),
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ── Estrelas de Relevância ─────────────────────────────────

class _RelevanciaStars extends StatelessWidget {
  final int nota;

  const _RelevanciaStars({required this.nota});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < nota ? Icons.star : Icons.star_border,
          size: 14,
          color: AppColors.warning,
        );
      }),
    );
  }
}

// ── Modelo de Identidade Visual (Value Object) ─────────────

class _IdentidadeVisual {
  final IconData icon;
  final Color color;
  final String tagText;

  const _IdentidadeVisual({
    required this.icon,
    required this.color,
    required this.tagText,
  });
}
