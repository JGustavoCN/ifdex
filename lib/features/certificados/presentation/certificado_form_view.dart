import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/features/certificados/models/certificado_types.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/widgets/certificado_cover.dart';
import 'package:ifdex/features/certificados/widgets/info_box.dart';

/// Formulário para **criar** ou **editar** certificados.
///
/// - Certificados **manuais**: todos os campos editáveis.
/// - Certificados **Sispubli**: Título, Instituição e Ano
///   são exibidos como texto estático (bloqueados). Apenas
///   metadados (Tags, Tipo, Relevância) são editáveis.
///   A seção de Comprovação (Upload/Link) é ocultada.
class CertificadoFormView extends ConsumerStatefulWidget {
  final String? id;

  const CertificadoFormView({super.key, this.id});

  @override
  ConsumerState<CertificadoFormView> createState() =>
      _CertificadoFormViewState();
}

class _CertificadoFormViewState extends ConsumerState<CertificadoFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloCtrl;
  late final TextEditingController _instituicaoCtrl;
  late final TextEditingController _anoCtrl;
  late final TextEditingController _cargaHorariaCtrl;
  late final TextEditingController _tagsCtrl;
  late final TextEditingController _linkCtrl;

  bool _isLink = true;
  int _notaRelevancia = 1;
  String _tipoSelecionado = 'Participação';

  Uint8List? _arquivoSelecionado;
  String? _nomeArquivoSelecionado;
  Certificado? _certificadoOriginal;

  bool get _isSispubli => _certificadoOriginal?.origem == Origem.sispubli;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _certificadoOriginal = ref.read(certificadoPorIdProvider(widget.id!));
    }

    final c = _certificadoOriginal;
    _tituloCtrl = TextEditingController(text: c?.titulo ?? '');
    _instituicaoCtrl = TextEditingController(text: c?.instituicao ?? '');
    _anoCtrl = TextEditingController(text: c?.ano.toString() ?? '');
    _cargaHorariaCtrl = TextEditingController(
      text: c?.cargaHoraria?.toString() ?? '',
    );
    _tagsCtrl = TextEditingController(text: c?.tags.join(', ') ?? '');
    _linkCtrl = TextEditingController(text: c?.urlDocumento ?? '');
    _isLink = c?.uploadDocumento == null;
    _notaRelevancia = c?.notaRelevancia ?? 1;
    _arquivoSelecionado = c?.uploadDocumento;

    _tipoSelecionado = c?.tipoDescricao ?? 'Participação';
    if (!CertificadoTypes.values.contains(_tipoSelecionado)) {
      _tipoSelecionado = 'Outros';
    }

    if (!_isSispubli) {
      _tituloCtrl.addListener(_updateUI);
      _instituicaoCtrl.addListener(_updateUI);
      _anoCtrl.addListener(_updateUI);
    }
  }

  void _updateUI() => setState(() {});

  @override
  void dispose() {
    if (!_isSispubli) {
      _tituloCtrl.removeListener(_updateUI);
      _instituicaoCtrl.removeListener(_updateUI);
      _anoCtrl.removeListener(_updateUI);
    }
    _tituloCtrl.dispose();
    _instituicaoCtrl.dispose();
    _anoCtrl.dispose();
    _cargaHorariaCtrl.dispose();
    _tagsCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarArquivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true,
    );
    if (result == null) return;
    final file = result.files.first;
    final tamanhoMB = file.size / (1024 * 1024);
    if (tamanhoMB > 10) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const AppText(
            'O arquivo excede o limite de 10MB.',
            color: AppColors.textOnPrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() {
      _arquivoSelecionado = file.bytes;
      _nomeArquivoSelecionado = file.name;
      _isLink = false;
      _linkCtrl.clear();
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final c = _certificadoOriginal;
    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Dados fixos do Sispubli são repassados intactos
    final titulo = _isSispubli ? c!.titulo : _tituloCtrl.text.trim();
    final instituicao = _isSispubli
        ? c!.instituicao
        : _instituicaoCtrl.text.trim();
    final ano = _isSispubli
        ? c!.ano
        : (int.tryParse(_anoCtrl.text.trim()) ?? DateTime.now().year);
    final origem = c?.origem ?? Origem.manual;

    // Comprovação: Sispubli mantém dados originais
    String? url;
    Uint8List? upload;
    if (_isSispubli) {
      url = c!.urlDocumento;
      upload = c.uploadDocumento;
    } else if (_isLink) {
      url = _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim();
    } else {
      upload = _arquivoSelecionado;
    }

    final cargaHoraria = int.tryParse(_cargaHorariaCtrl.text.trim());

    final novo = Certificado.criar(
      id: c?.id ?? const Uuid().v4(),
      origem: origem,
      titulo: titulo,
      ano: ano,
      instituicao: instituicao,
      tipoDescricao: _isSispubli ? c!.tipoDescricao : _tipoSelecionado,
      cargaHoraria: cargaHoraria,
      urlDocumento: url,
      uploadDocumento: upload,
      tags: tags,
      notaRelevancia: _notaRelevancia,
    );

    try {
      if (widget.id == null) {
        await ref
            .read(certificadosViewModelProvider.notifier)
            .adicionar(novo, fileName: _nomeArquivoSelecionado);
      } else {
        await ref
            .read(certificadosViewModelProvider.notifier)
            .adicionar(novo, fileName: _nomeArquivoSelecionado);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            widget.id == null
                ? 'Certificado salvo com sucesso!'
                : 'Certificado atualizado.',
            color: AppColors.textOnPrimary,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            e.toString().replaceAll('Exception: ', ''),
            color: AppColors.textOnPrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Widget _buildUploadBox() {
    final temArquivo = _arquivoSelecionado != null;
    return InkWell(
      onTap: _selecionarArquivo,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: temArquivo ? AppColors.successSoft : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: temArquivo ? AppColors.success : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              temArquivo
                  ? Icons.check_circle_outline
                  : Icons.cloud_upload_outlined,
              size: 48,
              color: temArquivo ? AppColors.success : AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            AppText(
              temArquivo
                  ? _nomeArquivoSelecionado ?? 'Arquivo selecionado'
                  : 'Selecione um arquivo '
                        '.pdf, .jpg ou .png',
              fontWeight: FontWeight.w700,
              color: temArquivo ? AppColors.success : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            AppText.label(
              temArquivo ? 'Toque para alterar' : 'Máx 10MB',
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    final isEdicao = widget.id != null;
    final labelSalvar = _isSispubli
        ? 'Salvar Metadados'
        : (isEdicao ? 'Salvar Edição' : 'Salvar Novo (+50 XP)');

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            // ── Título ──────────────────────────────
            if (_isSispubli)
              InfoBox(
                title: 'TÍTULO (BLOQUEADO)',
                child: AppText(_tituloCtrl.text, fontWeight: FontWeight.w700),
              )
            else
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título do Curso/Evento',
                  hintText: 'Ex: Desenvolvimento Web',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Obrigatório';
                  }
                  if (v.length > 100) {
                    return 'Máx. 100 caracteres';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 12),
            // ── Instituição ─────────────────────────
            if (_isSispubli)
              InfoBox(
                title: 'INSTITUIÇÃO (BLOQUEADO)',
                child: AppText(
                  _instituicaoCtrl.text,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              TextFormField(
                controller: _instituicaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instituição Emissora',
                  hintText: 'Ex: Udemy, IFS, AWS',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
            const SizedBox(height: 12),
            // ── Tipo + Ano ──────────────────────────
            Row(
              children: [
                Expanded(
                  child: _isSispubli
                      ? InfoBox(
                          title: 'TIPO (BLOQUEADO)',
                          child: AppText(
                            _tipoSelecionado,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          initialValue: _tipoSelecionado,
                          items: CertificadoTypes.values
                              .map(
                                (v) => DropdownMenuItem<String>(
                                  value: v,
                                  child: AppText(
                                    v,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _tipoSelecionado = v);
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Tipo'),
                          iconSize: 20,
                          isExpanded: true,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isSispubli
                      ? InfoBox(
                          title: 'ANO (BLOQUEADO)',
                          child: AppText(
                            _anoCtrl.text,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : TextFormField(
                          controller: _anoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Ano',
                            hintText: 'Ex: 2024',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Obrigatório';
                            }
                            final ano = int.tryParse(v.trim());
                            final atual = DateTime.now().year;
                            if (ano == null || ano < 1900 || ano > atual) {
                              return 'Inválido';
                            }
                            return null;
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // ── Relevância ──────────────────────────
            AppText.label(
              'RELEVÂNCIA PROFISSIONAL',
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _notaRelevancia = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      index < _notaRelevancia ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cargaHorariaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Carga Horária',
                      hintText: 'Opcional',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return null;
                      }
                      final ch = int.tryParse(v.trim());
                      if (ch == null || ch < 1 || ch > 5000) {
                        return 'Entre 1 e 5000';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _tagsCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tags (máx 5)',
                      hintText: 'Ex: Web, API',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return null;
                      }
                      final tags = v
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();
                      if (tags.length > 5) {
                        return 'Máx. 5 tags';
                      }
                      for (final tag in tags) {
                        if (tag.length > 20) {
                          return 'Máx. 20 chars/tag';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ── Comprovação (só Manual) ──────────────
            if (!_isSispubli) ...[
              AppText.label(
                'COMPROVAÇÃO (EXCLUSÃO MÚTUA)',
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
              const SizedBox(height: 10),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Link Externo'),
                    icon: Icon(Icons.link),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Upload Arquivo'),
                    icon: Icon(Icons.upload_file),
                  ),
                ],
                selected: {_isLink},
                onSelectionChanged: (set) {
                  setState(() {
                    _isLink = set.first;
                    if (_isLink) {
                      _arquivoSelecionado = null;
                      _nomeArquivoSelecionado = null;
                    } else {
                      _linkCtrl.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              if (_isLink)
                TextFormField(
                  controller: _linkCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Link Externo',
                    hintText: 'https://...',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (v) {
                    if (!_isLink) return null;
                    if (v == null || v.trim().isEmpty) {
                      return null;
                    }
                    final uri = Uri.tryParse(v.trim());
                    if (uri == null || !uri.hasAuthority) {
                      return 'URL inválida';
                    }
                    return null;
                  },
                )
              else
                _buildUploadBox(),
            ],
            const SizedBox(height: 24),
            // ── Botão Salvar ────────────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: AppText(
                  labelSalvar,
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.id != null;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final origem = _certificadoOriginal?.origem ?? Origem.manual;

    final appBarTitle = _isSispubli
        ? 'Editar Metadados'
        : (isEdicao ? 'Editar Certificado' : 'Registro Manual');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: AppText(
          appBarTitle,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: isMobile
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CertificadoCover(
                            titulo: _tituloCtrl.text.trim(),
                            instituicao: _instituicaoCtrl.text.trim(),
                            ano: _anoCtrl.text.trim(),
                            origem: origem,
                            isLink: _isLink,
                            width: double.infinity,
                          ),
                          _buildForm(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CertificadoCover(
                            titulo: _tituloCtrl.text.trim(),
                            instituicao: _instituicaoCtrl.text.trim(),
                            ano: _anoCtrl.text.trim(),
                            origem: origem,
                            isLink: _isLink,
                            width: 220,
                          ),
                          Expanded(
                            child: SingleChildScrollView(child: _buildForm()),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
