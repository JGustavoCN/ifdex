import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/sispubli/data/sispubli_datasource.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/shared/widgets/app_search_bar.dart';
import 'package:ifdex/shared/providers/busca_providers.dart';
import 'package:ifdex/features/sispubli/widgets/app_filtros_sispubli_bottom_sheet.dart';

/// Fase 2: Componente isolado para selecionar DTOs através de checkboxes.
/// Recebe a lista disponível (já deduplicada pelo Provider Computado)
/// e avisa a view pai quando o usuário decide "Importar".
class SispubliSelectionList extends ConsumerStatefulWidget {
  final List<SispubliCertificadoDto> disponiveis;
  final ValueChanged<List<SispubliCertificadoDto>> onImportar;

  const SispubliSelectionList({
    super.key,
    required this.disponiveis,
    required this.onImportar,
  });

  @override
  ConsumerState<SispubliSelectionList> createState() =>
      _SispubliSelectionListState();
}

class _SispubliSelectionListState extends ConsumerState<SispubliSelectionList> {
  final Set<String> _selecionados = {};
  bool _selecionarTodos = false;

  void _toggleTodos() {
    setState(() {
      if (_selecionarTodos) {
        _selecionados.clear();
        _selecionarTodos = false;
      } else {
        _selecionados.addAll(widget.disponiveis.map((d) => d.idUnico));
        _selecionarTodos = true;
      }
    });
  }

  void _toggleItem(String id) {
    setState(() {
      if (_selecionados.contains(id)) {
        _selecionados.remove(id);
        _selecionarTodos = false;
      } else {
        _selecionados.add(id);
      }
    });
  }

  void _iniciarImportacao() {
    final dtosParaImportar = widget.disponiveis
        .where((d) => _selecionados.contains(d.idUnico))
        .toList();
    widget.onImportar(dtosParaImportar);
  }

  @override
  Widget build(BuildContext context) {
    final qtdSelecionados = _selecionados.length;

    return Column(
      children: [
        // Busca
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: AppSearchBar(
            hintText: 'Filtrar disponíveis...',
            initialValue: ref.read(buscaSispubliProvider),
            onChanged: (val) {
              ref.read(buscaSispubliProvider.notifier).setQuery(val);
            },
          ),
        ),

        // Header com info e "Selecionar Todos"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  '${widget.disponiveis.length} novo(s)',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AppFiltrosSispubliBottomSheet(),
                  );
                },
                tooltip: 'Filtrar e Ordenar',
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              TextButton.icon(
                onPressed: _toggleTodos,
                icon: Icon(
                  _selecionarTodos ? Icons.deselect : Icons.select_all,
                  size: 18,
                ),
                label: AppText(
                  _selecionarTodos
                      ? 'Desmarcar Todos'
                      : 'Selecionar Todos '
                            '(${widget.disponiveis.length})',
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        // Lista com checkboxes
        Expanded(
          child: ListView.builder(
            itemCount: widget.disponiveis.length,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemBuilder: (context, index) {
              final dto = widget.disponiveis[index];
              final selecionado = _selecionados.contains(dto.idUnico);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: CheckboxListTile(
                  value: selecionado,
                  onChanged: (_) => _toggleItem(dto.idUnico),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: AppText(dto.titulo, fontWeight: FontWeight.w500),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        _Tag(label: dto.tipoDescricao),
                        const SizedBox(width: 8),
                        _Tag(label: '${dto.ano}'),
                        if (dto.urlDownload != null) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 14,
                            color: AppColors.error,
                          ),
                        ],
                      ],
                    ),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Botão de importar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: qtdSelecionados > 0 ? _iniciarImportacao : null,
              icon: const Icon(Icons.cloud_download_outlined, size: 20),
              label: AppText(
                qtdSelecionados > 0
                    ? 'Importar $qtdSelecionados Selecionado(s)'
                    : 'Selecione certificados',
                color: qtdSelecionados > 0
                    ? AppColors.textOnPrimary
                    : AppColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: AppText(label, fontSize: 11, color: AppColors.textSecondary),
    );
  }
}
