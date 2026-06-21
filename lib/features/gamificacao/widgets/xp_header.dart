import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/gamificacao/presentation/gamificacao_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Cabeçalho de gamificação para o layout mobile.
///
/// Exibe a logo, nível atual, XP acumulado, barra de
/// progresso e contagem de certificados. Usa [SafeArea]
/// para evitar sobreposição com a barra de notificações.
class XpHeader extends ConsumerWidget {
  const XpHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final g = ref.watch(gamificacaoViewModelProvider);
    final progresso = g.progressoPercent;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo + Branding ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo_transparent.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      const AppText(
                        'IFdex',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: AppColors.textOnPrimary,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Nível + XP ──────────────────────
              AppText(
                'LVL ${g.nivel} • '
                '${g.nomeNivel.toUpperCase()}',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
                letterSpacing: 1,
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: AppText(
                      '${g.totalXp} XP',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  if (g.nivel < 5)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: AppText(
                        '${g.xpRestante} XP restante',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Barra de progresso ──────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progresso,
                  minHeight: 10,
                  backgroundColor: AppColors.textOnPrimary.withValues(
                    alpha: 0.15,
                  ),
                  color: AppColors.success,
                ),
              ),

              const SizedBox(height: 14),

              // ── Portfólio (contagem) ────────────
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    '${g.totalCertificados} certificados guardados',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
