import 'package:flutter/material.dart';

import '../helpers/gamification.dart';
import '../models/certificado.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text.dart';
import '../widgets/certificado_card.dart';

/// Interface Web/Desktop da tela principal (>= 900px).
///
/// Adota layout de Painel com Sidebar lateral e
/// [GridView.builder] para distribuição em grade,
/// equivalente ao [ListView.builder] em otimização.
class HomeWebView extends StatelessWidget {
  final List<Certificado> certificadosFiltrados;
  final int totalCertificados;
  final int xp;
  final String filtroAtual;
  final ValueChanged<String> onFiltroChanged;
  final VoidCallback onAdicionarCertificado;
  final void Function(Certificado, int) onAbrirDetalhes;
  final void Function(int) onRemoverCertificado;

  const HomeWebView({
    super.key,
    required this.certificadosFiltrados,
    required this.totalCertificados,
    required this.xp,
    required this.filtroAtual,
    required this.onFiltroChanged,
    required this.onAdicionarCertificado,
    required this.onAbrirDetalhes,
    required this.onRemoverCertificado,
  });

  @override
  Widget build(BuildContext context) {
    final g = Gamification(xp);
    final progresso = g.progressoPercent.clamp(0.0, 1.0);

    return Row(
      children: [
        _Sidebar(gamification: g, progresso: progresso),
        Expanded(
          child: Column(
            children: [
              _TopBar(
                filtroAtual: filtroAtual,
                onFiltroChanged: onFiltroChanged,
                onAdicionarCertificado: onAdicionarCertificado,
              ),
              Expanded(
                child: _AreaPrincipal(
                  certificadosFiltrados: certificadosFiltrados,
                  totalCertificados: totalCertificados,
                  gamification: g,
                  onAbrirDetalhes: onAbrirDetalhes,
                  onRemoverCertificado: onRemoverCertificado,
                ),
              ),
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
    final xpDisplay = gamification.xp < 0 ? 0 : gamification.xp;
    final xpRestante = gamification.xpRestante < 0
        ? 0
        : gamification.xpRestante;

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
            '$xpDisplay XP',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnDark,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 5,
              backgroundColor: Colors.black.withValues(alpha: 0.2),
              color: Colors.lightGreenAccent,
            ),
          ),
          const SizedBox(height: 8),
          AppText(
            'Faltam $xpRestante XP',
            fontSize: 11,
            color: AppColors.textOnDark.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String filtroAtual;
  final ValueChanged<String> onFiltroChanged;
  final VoidCallback onAdicionarCertificado;

  const _TopBar({
    required this.filtroAtual,
    required this.onFiltroChanged,
    required this.onAdicionarCertificado,
  });

  String get _labelFiltro {
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
  Widget build(BuildContext context) {
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
            onSelected: onFiltroChanged,
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
                  AppText.label(_labelFiltro, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onAdicionarCertificado,
            icon: const Icon(Icons.add, size: 18),
            label: const AppText(
              'Novo Certificado',
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Área Principal (Stats + Grid) ──────────────────

class _AreaPrincipal extends StatelessWidget {
  final List<Certificado> certificadosFiltrados;
  final int totalCertificados;
  final Gamification gamification;
  final void Function(Certificado, int) onAbrirDetalhes;
  final void Function(int) onRemoverCertificado;

  const _AreaPrincipal({
    required this.certificadosFiltrados,
    required this.totalCertificados,
    required this.gamification,
    required this.onAbrirDetalhes,
    required this.onRemoverCertificado,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(
            total: totalCertificados,
            oficiais: certificadosFiltrados
                .where((c) => c.origem == Origem.sispubli)
                .length,
            gamification: gamification,
          ),
          const SizedBox(height: 32),
          certificadosFiltrados.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: AppText(
                      'Nenhum certificado '
                      'cadastrado.',
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                      onTap: () => onAbrirDetalhes(c, index),
                      onRemove: () => onRemoverCertificado(index),
                    );
                  },
                ),
        ],
      ),
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
    final xpDisplay = gamification.xp < 0 ? 0 : gamification.xp;

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
                  '$xpDisplay XP',
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
