import 'package:flutter/material.dart';
import '../models/certificado.dart';
import 'certificado_form_view.dart';

class CertificadoDetalhesDialog extends StatelessWidget {
  final Certificado certificado;
  final VoidCallback? onEdit;

  const CertificadoDetalhesDialog({
    super.key,
    required this.certificado,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 700;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 900 : 500),
        child: IntrinsicHeight(
          child: isWide
              ? Row(
                  children: [
                    _Cover(certificado: certificado),
                    Expanded(
                      child: _Info(
                        certificado: certificado,
                        onEdit: onEdit,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Cover(certificado: certificado, height: 180),
                    _Info(
                      certificado: certificado,
                      onEdit: onEdit,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final Certificado certificado;
  final double? height;

  const _Cover({required this.certificado, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: height ?? double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2F66F3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          bottomLeft: Radius.circular(22),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shield_outlined, size: 56, color: Colors.white70),
          const SizedBox(height: 18),
          Text(
            certificado.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${certificado.instituicao} • ${certificado.ano}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final Certificado certificado;
  final VoidCallback? onEdit;

  const _Info({
    required this.certificado,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final podeEditar = certificado.origem == Origem.manual && onEdit != null;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const Text(
                'RELEVÂNCIA PROFISSIONAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (_) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.star, color: Color(0xFFF6B52E), size: 24),
                  );
                }),
              ),
              const SizedBox(height: 18),
              _Box(
                title: 'CARGA HORÁRIA',
                child: Text(
                  '${certificado.cargaHoraria ?? 0} Horas',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              _Box(
                title: 'METADADOS ENVIÁVEIS (TAGS)',
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: certificado.tags
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              _Box(
                title: 'IDENTIFICADOR DE SEGURANÇA',
                child: Text(
                  'uid_v4:1',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (podeEditar)
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar Link'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('FECHAR'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final String title;
  final Widget child;

  const _Box({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}