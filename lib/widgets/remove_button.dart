import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const RemoveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      tooltip: 'Remover',
      onPressed: onPressed,
    );
  }
}
