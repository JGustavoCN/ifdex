import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/providers/ordenacao_providers.dart';
import 'package:ifdex/shared/models/ordenacao_enum.dart';

class AppFiltrosBottomSheet extends ConsumerWidget {
  const AppFiltrosBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtros = ref.watch(filtroCertificadosProvider);
    final instAtivas = ref.watch(instituicoesAtivasProvider);
    final tiposAtivosList = ref.watch(tiposAtivosProvider);
    final tagsAtivasList = ref.watch(tagsAtivasProvider);
    final anosAtivosList = ref.watch(anosAtivosProvider);
    final ordenacao = ref.watch(ordenacaoHomeStateProvider);

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
              AppText.headline('Filtros Avançados'),
              TextButton(
                onPressed: () => ref
                    .read(filtroCertificadosProvider.notifier)
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
                  DropdownButtonFormField<OrdenacaoHome>(
                    initialValue: ordenacao,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: OrdenacaoHome.values.map((o) {
                      return DropdownMenuItem<OrdenacaoHome>(
                        value: o,
                        child: Text(o.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(ordenacaoHomeStateProvider.notifier)
                            .setOrdem(val);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Seção 1: Origem
                  Row(
                    children: [
                      const Icon(
                        Icons.source,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Origem do Certificado'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'todos', label: Text('Todos')),
                      ButtonSegment(value: 'oficial', label: Text('Oficiais')),
                      ButtonSegment(value: 'manual', label: Text('Manuais')),
                    ],
                    selected: {filtros.origemSelecionada},
                    onSelectionChanged: (set) {
                      if (set.isNotEmpty) {
                        ref
                            .read(filtroCertificadosProvider.notifier)
                            .setOrigem(set.first);
                      }
                    },
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.primarySoft,
                      selectedForegroundColor: AppColors.primary,
                    ),
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
                            .read(filtroCertificadosProvider.notifier)
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
                                .read(filtroCertificadosProvider.notifier)
                                .toggleTipo(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Seção 2: Instituições
                  Row(
                    children: [
                      const Icon(
                        Icons.business,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Instituições / Plataformas'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (instAtivas.isEmpty)
                    const AppText(
                      'Nenhuma instituição detectada.',
                      color: AppColors.textSecondary,
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8,
                        children: instAtivas.map((inst) {
                          final isSelected = filtros.instituicoesSelecionadas
                              .contains(inst);
                          return FilterChip(
                            label: Text(inst),
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
                                .read(filtroCertificadosProvider.notifier)
                                .toggleInstituicao(inst),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Seção: Tags
                  Row(
                    children: [
                      const Icon(
                        Icons.local_offer,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Tags'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (tagsAtivasList.isEmpty)
                    const AppText(
                      'Nenhuma tag detectada.',
                      color: AppColors.textSecondary,
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8,
                        children: tagsAtivasList.map((tag) {
                          final isSelected = filtros.tagsSelecionadas.contains(
                            tag,
                          );
                          return FilterChip(
                            label: Text(tag),
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
                                .read(filtroCertificadosProvider.notifier)
                                .toggleTag(tag),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Seção 3: Estrelas
                  Row(
                    children: [
                      const Icon(
                        Icons.star_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Nota de Relevância (Estrelas)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(5, (index) {
                      final estrela = index + 1;
                      final isSelected = filtros.estrelasSelecionadas.contains(
                        estrela,
                      );
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$estrela '),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: isSelected
                                  ? AppColors.warning
                                  : AppColors.textDisabled,
                            ),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.warning.withValues(alpha: 0.1),
                        checkmarkColor: AppColors.warning,
                        onSelected: (_) => ref
                            .read(filtroCertificadosProvider.notifier)
                            .toggleEstrela(estrela),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Seção 4: Carga Horária
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      AppText.label('Carga Horária (horas)'),
                      const Spacer(),
                      AppText(
                        '${filtros.minCargaHoraria}h - ${filtros.maxCargaHoraria}h',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(
                      filtros.minCargaHoraria.toDouble(),
                      filtros.maxCargaHoraria.toDouble(),
                    ),
                    min: 0,
                    max: 5000,
                    divisions: 100,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    onChanged: (RangeValues values) {
                      ref
                          .read(filtroCertificadosProvider.notifier)
                          .setCargaHoraria(
                            values.start.round(),
                            values.end.round(),
                          );
                    },
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
