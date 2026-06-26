import 'package:flutter/material.dart';

import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Container estilizado para agrupar informações em um
/// campo visual consistente com o Design System.
///
/// Utiliza [AppColors.surfaceAlt] como fundo e
/// [AppColors.border] como borda, com cantos arredondados
/// de 14px (token `rounded.md` do DESIGN.md).
class AppInfoBox extends StatelessWidget {
  final String? title;
  final Widget child;

  const AppInfoBox({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) ...[
            AppText.label(
              title!,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}
