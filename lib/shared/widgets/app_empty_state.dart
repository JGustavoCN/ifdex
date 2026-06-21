import 'package:flutter/material.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;

  const AppEmptyState({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            message,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          if (subMessage != null) ...[
            const SizedBox(height: 6),
            AppText(
              subMessage!,
              color: AppColors.textMuted,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
