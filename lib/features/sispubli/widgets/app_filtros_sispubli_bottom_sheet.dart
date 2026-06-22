import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_providers.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/providers/ordenacao_providers.dart';
import 'package:ifdex/shared/models/ordenacao_enum.dart';

class AppFiltrosSispubliBottomSheet extends ConsumerWidget {
  const AppFiltrosSispubliBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtros = ref.watch(filtroSispubliNotifierProvider);
    final tiposAtivosList = ref.watch(tiposAtivosSispubliProvider);
    final anosAtivosList = ref.watch(anosAtivosSispubliProvider);
    final ordenacao = ref.watch(ordenacaoSispubliStateProvider);

    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.headline('Filtros da Importação'),
              TextButton(
                onPressed: () => ref
                    .read(filtroSispubliNotifierProvider.notifier)
                    .limparFiltros(),
                child: const AppText('Limpar', color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seção: Ordenação
                  Row(
                    children: [
                      const Icon(
                        Icons.sort,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Ordenar por'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<OrdenacaoSispubli>(
                    initialValue: ordenacao,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: OrdenacaoSispubli.values.map((o) {
                      return DropdownMenuItem<OrdenacaoSispubli>(
                        value: o,
                        child: Text(o.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(ordenacaoSispubliStateProvider.notifier)
                            .setOrdem(val);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  // Seção: Anos
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Ano do Certificado'),
                      const Spacer(),
                      AppText(
                        '${filtros.minAno ?? (anosAtivosList.isNotEmpty ? anosAtivosList.last : 'Todos')} - ${filtros.maxAno ?? (anosAtivosList.isNotEmpty ? anosAtivosList.first : 'Todos')}',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (anosAtivosList.isEmpty)
                    const AppText(
                      'Nenhum ano detectado.',
                      color: AppColors.textSecondary,
                    )
                  else if (anosAtivosList.length == 1)
                    AppText(
                      'Apenas certificados de ${anosAtivosList.first}.',
                      color: AppColors.textSecondary,
                    )
                  else
                    RangeSlider(
                      values: RangeValues(
                        (filtros.minAno ?? anosAtivosList.last).toDouble(),
                        (filtros.maxAno ?? anosAtivosList.first).toDouble(),
                      ),
                      min: anosAtivosList.last.toDouble(),
                      max: anosAtivosList.first.toDouble(),
                      divisions: anosAtivosList.first - anosAtivosList.last > 0
                          ? anosAtivosList.first - anosAtivosList.last
                          : 1,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.border,
                      labels: RangeLabels(
                        (filtros.minAno ?? anosAtivosList.last).toString(),
                        (filtros.maxAno ?? anosAtivosList.first).toString(),
                      ),
                      onChanged: (RangeValues values) {
                        ref
                            .read(filtroSispubliNotifierProvider.notifier)
                            .setAno(values.start.round(), values.end.round());
                      },
                    ),
                  const SizedBox(height: 24),

                  // Seção: Tipos
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Tipos de Participação'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (tiposAtivosList.isEmpty)
                    const AppText(
                      'Nenhum tipo detectado.',
                      color: AppColors.textSecondary,
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8,
                        children: tiposAtivosList.map((tipo) {
                          final isSelected = filtros.tiposSelecionados.contains(
                            tipo,
                          );
                          return FilterChip(
                            label: Text(tipo),
                            selected: isSelected,
                            selectedColor: AppColors.primarySoft,
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            onSelected: (_) => ref
                                .read(filtroSispubliNotifierProvider.notifier)
                                .toggleTipo(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const AppText(
                'Aplicar Filtros',
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
