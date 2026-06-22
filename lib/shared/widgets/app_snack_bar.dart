import 'package:flutter/material.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Tipos de feedback visual disponíveis no sistema.
///
/// Cada tipo possui cor de destaque, fundo, ícone e duração próprios,
/// garantindo comunicação clara e consistente em toda a aplicação.
///
/// ### Uso obrigatório
/// Toda comunicação de status ao usuário (sucesso, erro, aviso,
/// informação) **DEVE** utilizar `AppSnackBar.show(...)` ao invés
/// de `ScaffoldMessenger` direto. Consulte os exemplos abaixo.
///
/// ```dart
/// // ✅ Correto
/// AppSnackBar.show(context, type: SnackType.success, message: '...');
///
/// // ❌ Proibido
/// ScaffoldMessenger.of(context).showSnackBar(SnackBar(...));
/// ```
enum SnackType { success, error, warning, info }

/// Componente padronizado de feedback visual do IFdex.
///
/// Renderiza um toast customizado no **topo** da tela com:
/// - Barra lateral colorida (accent do tipo)
/// - Fundo em tom suave (`*Soft` do Design System)
/// - Ícone contextual
/// - Duração calibrada por tipo
///
/// **Regra de padrão:** Este é o ÚNICO componente autorizado
/// para exibir notificações efêmeras no aplicativo.
class AppSnackBar {
  /// Exibe um SnackBar customizado no topo da tela.
  ///
  /// [type] define a semântica visual (cores, ícone, duração).
  /// [message] é o texto exibido ao usuário.
  static void show(
    BuildContext context, {
    required SnackType type,
    required String message,
  }) {
    final config = _configFor(type);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 600;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      margin: isDesktop
          ? null
          : const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      width: isDesktop ? 400 : null,
      padding: EdgeInsets.zero,
      duration: config.duration,
      content: Container(
        decoration: BoxDecoration(
          color: config.bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: config.accentColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: config.accentColor.withValues(alpha: 0.25),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 6, color: config.accentColor),
                  const SizedBox(width: 14),
                  Icon(config.iconData, color: config.accentColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: AppText(
                        message,
                        color: config.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static _SnackConfig _configFor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const _SnackConfig(
          accentColor: AppColors.success,
          bgColor: AppColors.successSoft,
          textColor: Color(0xFF15532B),
          iconData: Icons.check_circle_rounded,
          duration: Duration(seconds: 3),
        );
      case SnackType.error:
        return const _SnackConfig(
          accentColor: AppColors.error,
          bgColor: AppColors.errorSoft,
          textColor: Color(0xFF7F1D1D),
          iconData: Icons.error_rounded,
          duration: Duration(seconds: 5),
        );
      case SnackType.warning:
        return const _SnackConfig(
          accentColor: AppColors.warning,
          bgColor: AppColors.warningSoft,
          textColor: Color(0xFF78350F),
          iconData: Icons.warning_amber_rounded,
          duration: Duration(seconds: 4),
        );
      case SnackType.info:
        return const _SnackConfig(
          accentColor: AppColors.info,
          bgColor: AppColors.infoSoft,
          textColor: Color(0xFF1E3A5F),
          iconData: Icons.info_rounded,
          duration: Duration(seconds: 3),
        );
    }
  }
}

class _SnackConfig {
  final Color accentColor;
  final Color bgColor;
  final Color textColor;
  final IconData iconData;
  final Duration duration;

  const _SnackConfig({
    required this.accentColor,
    required this.bgColor,
    required this.textColor,
    required this.iconData,
    required this.duration,
  });
}
