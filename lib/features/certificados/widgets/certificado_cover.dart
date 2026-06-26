import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Card visual "Smart Mock" que exibe a identidade do
/// certificado.
///
/// Suporta modo estático (dados finais de um [Certificado])
/// e dinâmico (preview do formulário via parâmetros de texto).
class CertificadoCover extends StatelessWidget {
  final String titulo;
  final String instituicao;
  final String ano;
  final Origem origem;
  final bool isLink;
  final double width;
  final double? height;

  const CertificadoCover({
    super.key,
    required this.titulo,
    required this.instituicao,
    required this.ano,
    required this.origem,
    this.isLink = true,
    required this.width,
    this.height,
  });

  /// Construtor de conveniência a partir de um [Certificado]
  /// existente (modo estático para a DetailsView).
  factory CertificadoCover.fromCertificado(
    Certificado certificado, {
    Key? key,
    required double width,
    double? height,
  }) {
    final temLink =
        certificado.urlDocumento != null &&
        certificado.urlDocumento!.isNotEmpty;

    return CertificadoCover(
      key: key,
      titulo: certificado.titulo,
      instituicao: certificado.instituicao,
      ano: certificado.ano.toString(),
      origem: certificado.origem,
      isLink: temLink,
      width: width,
      height: height,
    );
  }

  IconData _getIcon() {
    if (origem == Origem.sispubli) return Icons.account_balance;
    final inst = instituicao.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return Icons.cloud_outlined;
    }
    if (inst.contains('udemy')) return Icons.play_circle_outline;
    return isLink ? Icons.link : Icons.folder_open_outlined;
  }

  String? _getAssetPath() {
    if (origem == Origem.sispubli) return 'assets/logo_ifs.svg';
    final inst = instituicao.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return 'assets/aws.svg';
    }
    if (inst.contains('udemy')) return 'assets/udemy.svg';
    return null;
  }

  Size _getAssetSize(bool isCompact) {
    if (origem == Origem.sispubli) {
      return Size(isCompact ? 36 : 56, isCompact ? 36 : 56);
    }
    final inst = instituicao.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return Size(isCompact ? 32 : 48, isCompact ? 32 : 48);
    }
    if (inst.contains('udemy')) {
      return Size(isCompact ? 70 : 110, isCompact ? 25 : 38);
    }
    return Size(isCompact ? 36 : 56, isCompact ? 36 : 56);
  }

  Color _getColor() {
    if (origem == Origem.sispubli) return AppColors.primary;
    final inst = instituicao.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return AppColors.warning;
    }
    if (inst.contains('udemy')) return const Color(0xFF8B5CF6);
    return AppColors.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final displayTitulo = titulo.isEmpty ? 'Título do Certificado' : titulo;
    final displayInst = instituicao.isEmpty ? 'Instituição' : instituicao;
    final displayAno = ano.isEmpty ? 'Ano' : ano;

    final cor = _getColor();
    final icone = _getIcon();
    final isCompact = width < 150;

    return Container(
      width: width,
      height: height,
      constraints: height == null ? const BoxConstraints(minHeight: 140) : null,
      decoration: BoxDecoration(color: cor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (_getAssetPath() != null)
              SizedBox(
                width: _getAssetSize(isCompact).width,
                height: _getAssetSize(isCompact).height,
                child: SvgPicture.asset(
                  _getAssetPath()!,
                  width: _getAssetSize(isCompact).width,
                  height: _getAssetSize(isCompact).height,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Colors.white70,
                    BlendMode.srcIn,
                  ),
                ),
              )
            else
              Icon(icone, size: isCompact ? 36 : 56, color: Colors.white70),
            const SizedBox(height: 10),
            AppText(
              displayTitulo,
              textAlign: TextAlign.center,
              fontSize: isCompact ? 14 : 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: 6),
            AppText(
              '$displayInst • $displayAno',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: isCompact ? 10 : 13,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
