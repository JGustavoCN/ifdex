import 'package:flutter/material.dart';
import '../models/certificado.dart';
import 'app_text.dart';

class RemoveButton extends StatelessWidget {
  final Certificado certificado;
  final VoidCallback onConfirmDelete;

  const RemoveButton({
    super.key,
    required this.certificado,
    required this.onConfirmDelete,
  });

  void _mostrarDialogoDeConfirmacao(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteCertificateDialog(
          tituloCertificado: certificado.titulo,
          onConfirm: onConfirmDelete,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;

    return IconButton(
      icon: Icon(Icons.delete_outline, color: errorColor),
      tooltip: 'Remover Certificado',
      onPressed: () => _mostrarDialogoDeConfirmacao(context),
    );
  }
}

class DeleteCertificateDialog extends StatelessWidget {
  final String tituloCertificado;
  final VoidCallback onConfirm;

  const DeleteCertificateDialog({
    super.key,
    required this.tituloCertificado,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color errorColor = theme.colorScheme.error;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_outline, color: errorColor, size: 32),
          ),
          const SizedBox(height: 16),
          AppText.headline('Atenção!'),
          const SizedBox(height: 8),
          AppText.body(
            'Tem certeza que deseja excluir o certificado "$tituloCertificado"? Você perderá 50 XP.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText.body('Cancelar', color: theme.colorScheme.primary),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const AppText(
            'Excluir',
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
