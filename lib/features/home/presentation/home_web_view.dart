import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/gamificacao/models/gamification.dart';
import 'package:ifdex/features/gamificacao/presentation/gamificacao_view_model.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/widgets/certificado_card.dart';
import 'package:ifdex/features/certificados/presentation/certificado_details_view.dart';
import 'package:ifdex/features/certificados/presentation/certificado_form_view.dart';
import 'package:ifdex/features/auth/presentation/profile_view.dart';

import 'package:ifdex/shared/widgets/app_loading_state.dart';
import 'package:ifdex/shared/widgets/app_error_state.dart';
import 'package:ifdex/shared/widgets/app_empty_state.dart';

class HomeWebView extends ConsumerWidget {
  const HomeWebView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificacaoViewModelProvider);
    final progresso = gamification.progressoPercent;

    return Row(
      children: [
        _Sidebar(gamification: gamification, progresso: progresso),
        Expanded(
          child: Column(
            children: [
              const _TopBar(),
              Expanded(child: _AreaPrincipal(gamification: gamification)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Sidebar ────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final Gamification gamification;
  final double progresso;

  const _Sidebar({required this.gamification, required this.progresso});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/logo_transparent.png', height: 32, width: 32),
              const SizedBox(width: 12),
              const AppText(
                'IFdex',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnDark,
              ),
            ],
          ),
          const SizedBox(height: 48),
          const _SidebarItem(
            icon: Icons.grid_view,
            label: 'Carteira',
            isActive: true,
          ),
          const _SidebarItem(icon: Icons.filter_list, label: 'Categorias'),
          const Spacer(),
          _XpSidebarCard(gamification: gamification, progresso: progresso),
        ],
      ),
    );
  }
}

// ── Item da Sidebar ────────────────────────────────

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.textOnDark
        : AppColors.textOnDark.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          AppText(
            label,
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

// ── Card XP na Sidebar ─────────────────────────────

class _XpSidebarCard extends StatelessWidget {
  final Gamification gamification;
  final double progresso;

  const _XpSidebarCard({required this.gamification, required this.progresso});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          AppText.label(
            'LVL ${gamification.nivel} • '
            '${gamification.nomeNivel.toUpperCase()}',
            color: AppColors.warning,
            letterSpacing: 1,
          ),
          const SizedBox(height: 8),
          AppText(
            '${gamification.totalXp} XP',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnDark,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 6,
              backgroundColor: Colors.black.withValues(alpha: 0.2),
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          AppText(
            gamification.nivel < 5
                ? 'Faltam ${gamification.xpRestante} XP'
                : 'Nível máximo!',
            fontSize: 11,
            color: AppColors.textOnDark.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  const _TopBar();

  String _labelFiltro(String filtroAtual) {
    switch (filtroAtual) {
      case 'oficial':
        return 'Oficiais';
      case 'manual':
        return 'Manuais';
      default:
        return 'Todos';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtroAtual = ref.watch(filtroCertificadosProvider);

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          AppText.headline('Dashboard Acadêmico'),
          const Spacer(),
          PopupMenuButton<String>(
            onSelected: (novo) =>
                ref.read(filtroCertificadosProvider.notifier).setFiltro(novo),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'todos', child: AppText('Todos')),
              const PopupMenuItem(value: 'oficial', child: AppText('Oficiais')),
              const PopupMenuItem(value: 'manual', child: AppText('Manuais')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  AppText.label(
                    _labelFiltro(filtroAtual),
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const CertificadoFormView(),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const AppText(
              'Novo Certificado',
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const ProfileView()),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Área Principal (Stats + Grid) ──────────────────

class _AreaPrincipal extends ConsumerWidget {
  final Gamification gamification;

  const _AreaPrincipal({required this.gamification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCertificados = ref.watch(certificadosViewModelProvider);

    return asyncCertificados.when(
      loading: () => const AppLoadingState(),
      error: (err, stack) => AppErrorState(
        message: err.toString(),
        onRetry: () => ref.invalidate(certificadosViewModelProvider),
      ),
      data: (_) {
        final certificadosFiltrados = ref.watch(certificadosFiltradosProvider);
        final totalOficiais = certificadosFiltrados
            .where((c) => c.origem == Origem.sispubli)
            .length;

        // Utilizamos ref.read ao invés de watch para evitar recarregar apenas o total aqui se o list view fizer isso
        final totalCertificados = ref.watch(
          certificadosViewModelProvider.select(
            (state) => state.value?.length ?? 0,
          ),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatsRow(
                total: totalCertificados,
                oficiais: totalOficiais,
                gamification: gamification,
              ),
              const SizedBox(height: 32),
              certificadosFiltrados.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 64),
                      child: AppEmptyState(
                        message: 'Cofre vazio',
                        subMessage:
                            'Adicione seu primeiro certificado e comece a ganhar XP!',
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 350,
                            mainAxisExtent: 320,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: certificadosFiltrados.length,
                      itemBuilder: (context, index) {
                        final c = certificadosFiltrados[index];
                        return CertificadoCard(
                          certificado: c,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    CertificadoDetailsView(id: c.id),
                              ),
                            );
                          },
                          onRemove: () {
                            ref
                                .read(certificadosViewModelProvider.notifier)
                                .remover(c.id);
                          },
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ── Linha de Stats ─────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int total;
  final int oficiais;
  final Gamification gamification;

  const _StatsRow({
    required this.total,
    required this.oficiais,
    required this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _StatCard(
          icon: Icons.description_outlined,
          label: 'Total',
          value: '$total',
          iconBgColor: AppColors.primarySoft,
          iconColor: AppColors.primary,
        ),
        _StatCard(
          icon: Icons.verified_outlined,
          label: 'Oficiais (IFS)',
          value: '$oficiais',
          iconBgColor: AppColors.secondarySoft,
          iconColor: AppColors.secondary,
        ),
        _XpStatCard(gamification: gamification),
      ],
    );
  }
}

// ── Card de Estatística ────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBgColor;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.label(label),
                AppText(value, fontSize: 22, fontWeight: FontWeight.w800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card XP Compacto (Stats Row) ───────────────────

class _XpStatCard extends StatelessWidget {
  final Gamification gamification;

  const _XpStatCard({required this.gamification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.label(
                  gamification.nomeNivel.toUpperCase(),
                  color: AppColors.textOnDark.withValues(alpha: 0.8),
                ),
                AppText(
                  '${gamification.totalXp} XP',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textOnDark,
                ),
              ],
            ),
          ),
          const Icon(Icons.emoji_events, color: AppColors.warning, size: 36),
        ],
      ),
    );
  }
}
