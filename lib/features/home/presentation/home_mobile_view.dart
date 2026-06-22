import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/widgets/certificado_card.dart';
import 'package:ifdex/features/gamificacao/widgets/xp_header.dart';
import 'package:ifdex/features/certificados/presentation/certificado_details_view.dart';

import 'package:ifdex/shared/widgets/app_loading_state.dart';
import 'package:ifdex/shared/widgets/app_error_state.dart';
import 'package:ifdex/shared/widgets/app_empty_state.dart';
import 'package:ifdex/shared/widgets/app_search_bar.dart';
import 'package:ifdex/shared/providers/busca_providers.dart';
import 'package:ifdex/shared/widgets/app_filtros_bottom_sheet.dart';

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
            loading: () => const AppLoadingState(),
            error: (err, stack) => AppErrorState(
              message: err.toString(),
              onRetry: () => ref.invalidate(certificadosViewModelProvider),
            ),
            data: (_) {
              final certificadosFiltrados = ref.watch(
                certificadosFiltradosProvider,
              );
              if (certificadosFiltrados.isEmpty) {
                return const AppEmptyState(
                  message: 'Cofre vazio',
                  subMessage:
                      'Adicione seu primeiro certificado\ne comece a ganhar XP!',
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                'Meus Certificados',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: 'Filtrar e Ordenar',
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AppFiltrosBottomSheet(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppSearchBar(
            initialValue: ref.read(buscaHomeProvider),
            onChanged: (val) {
              ref.read(buscaHomeProvider.notifier).setQuery(val);
            },
          ),
        ],
      ),
    );
  }
}
