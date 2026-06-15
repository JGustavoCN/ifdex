import 'package:flutter/material.dart';

import '../models/certificado.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text.dart';
import '../widgets/certificado_card.dart';
import '../widgets/xp_header.dart';

/// Interface Mobile da tela principal (< 900px).
///
/// Recebe dados e callbacks do [HomeView] (StatefulWidget
/// pai) e renderiza a listagem via [ListView.builder]
/// obrigatório para otimização de memória.
class HomeMobileView extends StatelessWidget {
  final List<Certificado> certificadosFiltrados;
  final int totalCertificados;
  final String filtroAtual;
  final ValueChanged<String> onFiltroChanged;
  final VoidCallback onAdicionarCertificado;
  final void Function(Certificado, int) onAbrirDetalhes;
  final void Function(int) onRemoverCertificado;

  const HomeMobileView({
    super.key,
    required this.certificadosFiltrados,
    required this.totalCertificados,
    required this.filtroAtual,
    required this.onFiltroChanged,
    required this.onAdicionarCertificado,
    required this.onAbrirDetalhes,
    required this.onRemoverCertificado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XpHeader(totalCertificados: totalCertificados),
        _BarraFiltros(
          filtroAtual: filtroAtual,
          onFiltroChanged: onFiltroChanged,
        ),
        Expanded(
          child: certificadosFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      const AppText(
                        'Cofre vazio',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      const AppText(
                        'Adicione seu primeiro '
                        'certificado\n'
                        'e comece a ganhar XP!',
                        color: AppColors.textMuted,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: certificadosFiltrados.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final c = certificadosFiltrados[index];
                    return CertificadoCard(
                      certificado: c,
                      onTap: () => onAbrirDetalhes(c, index),
                      onRemove: () => onRemoverCertificado(index),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Barra de Filtros ───────────────────────────────

class _BarraFiltros extends StatelessWidget {
  final String filtroAtual;
  final ValueChanged<String> onFiltroChanged;

  const _BarraFiltros({
    required this.filtroAtual,
    required this.onFiltroChanged,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.label('PORTFÓLIO', letterSpacing: 1),
          PopupMenuButton<String>(
            onSelected: onFiltroChanged,
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'todos', child: AppText('Todos')),
              const PopupMenuItem(value: 'oficial', child: AppText('Oficiais')),
              const PopupMenuItem(value: 'manual', child: AppText('Manuais')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
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
        ],
      ),
    );
  }
}
