import 'package:flutter/material.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/shared/widgets/app_confirm_dialog.dart';

class RemoveButton extends StatelessWidget {
  final Certificado certificado;
  final VoidCallback onConfirmDelete;

  const RemoveButton({
    super.key,
    required this.certificado,
    required this.onConfirmDelete,
  });

  Future<void> _mostrarDialogoDeConfirmacao(BuildContext context) async {
    final ok = await AppConfirmDialog.show(
      context,
      title: 'Atenção!',
      description:
          'Tem certeza que deseja excluir o certificado "${certificado.titulo}"? Você perderá 50 XP.',
      confirmLabel: 'Excluir',
    );

    if (ok) {
      onConfirmDelete();
    }
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
