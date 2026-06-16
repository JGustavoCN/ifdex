import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/widgets/certificado_card.dart';
import 'package:ifdex/features/gamificacao/widgets/xp_header.dart';
import 'package:ifdex/features/certificados/presentation/certificado_details_view.dart';

class HomeMobileView extends ConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCertificados = ref.watch(certificadosViewModelProvider);

    return Column(
      children: [
        const XpHeader(),
        const _BarraFiltros(),
        Expanded(
          child: asyncCertificados.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
            data: (_) {
              final certificadosFiltrados = ref.watch(
                certificadosFiltradosProvider,
              );
              if (certificadosFiltrados.isEmpty) {
                return Center(
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
                );
              }

              return ListView.builder(
                itemCount: certificadosFiltrados.length,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) {
                  final c = certificadosFiltrados[index];
                  return CertificadoCard(
                    certificado: c,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => CertificadoDetailsView(id: c.id),
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
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BarraFiltros extends ConsumerWidget {
  const _BarraFiltros();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtroAtual = ref.watch(filtroCertificadosProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText(
            'Meus Certificados',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: filtroAtual,
              icon: const Icon(
                Icons.filter_list,
                color: AppColors.primary,
                size: 20,
              ),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              items: const [
                DropdownMenuItem(value: 'todos', child: Text('Todos')),
                DropdownMenuItem(
                  value: 'oficial',
                  child: Text('Oficiais (IFS)'),
                ),
                DropdownMenuItem(value: 'manual', child: Text('Adicionados')),
              ],
              onChanged: (novo) {
                if (novo != null) {
                  ref.read(filtroCertificadosProvider.notifier).setFiltro(novo);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
