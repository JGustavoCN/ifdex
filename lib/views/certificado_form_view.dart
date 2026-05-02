import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/certificado.dart';
import '../theme/app_theme.dart';

class CertificadoFormView extends StatefulWidget {
  final Certificado? certificado;
  final int? editIndex;

  const CertificadoFormView({super.key, this.certificado, this.editIndex});

  @override
  State<CertificadoFormView> createState() => _CertificadoFormViewState();
}

class _CertificadoFormViewState extends State<CertificadoFormView> {
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

  final List<String> _tipos = [
    'Participação',
    'Curso',
    'Palestra',
    'Certificação',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.certificado;
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

    _tipoSelecionado = c?.tipoDescricao ?? 'Participação';
    if (!_tipos.contains(_tipoSelecionado)) {
      _tipos.add(_tipoSelecionado);
    }

    _tituloCtrl.addListener(_updateUI);
    _instituicaoCtrl.addListener(_updateUI);
    _anoCtrl.addListener(_updateUI);
  }

  void _updateUI() => setState(() {});

  @override
  void dispose() {
    _tituloCtrl.removeListener(_updateUI);
    _instituicaoCtrl.removeListener(_updateUI);
    _anoCtrl.removeListener(_updateUI);
    _tituloCtrl.dispose();
    _instituicaoCtrl.dispose();
    _anoCtrl.dispose();
    _cargaHorariaCtrl.dispose();
    _tagsCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    final origem = widget.certificado?.origem ?? Origem.manual;
    if (origem == Origem.sispubli) return Icons.account_balance;
    final inst = _instituicaoCtrl.text.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return Icons.cloud_outlined;
    }
    if (inst.contains('udemy')) return Icons.play_circle_outline;
    return _isLink ? Icons.link : Icons.folder_open_outlined;
  }

  Color _getColor() {
    final origem = widget.certificado?.origem ?? Origem.manual;
    if (origem == Origem.sispubli) return AppColors.primary;
    final inst = _instituicaoCtrl.text.toLowerCase();
    if (inst.contains('aws') || inst.contains('amazon')) {
      return AppColors.warning;
    }
    if (inst.contains('udemy')) return const Color(0xFF8B5CF6);
    return AppColors.secondary;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final isSispubli = widget.certificado?.origem == Origem.sispubli;

    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String? url;
    Uint8List? upload;

    if (isSispubli) {
      url = widget.certificado?.urlDocumento;
      upload = widget.certificado?.uploadDocumento;
    } else {
      if (_isLink) {
        url = _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim();
      } else {
        upload = Uint8List.fromList([0]);
      }
    }

    final novo = Certificado.criar(
      id: widget.certificado?.id ?? const Uuid().v4(),
      origem: widget.certificado?.origem ?? Origem.manual,
      titulo: _tituloCtrl.text.trim(),
      ano: int.tryParse(_anoCtrl.text.trim()) ?? DateTime.now().year,
      instituicao: _instituicaoCtrl.text.trim(),
      tipoDescricao: isSispubli
          ? (widget.certificado?.tipoDescricao ?? 'Manual')
          : _tipoSelecionado,
      cargaHoraria: isSispubli
          ? null
          : int.tryParse(_cargaHorariaCtrl.text.trim()),
      urlDocumento: url,
      uploadDocumento: upload,
      tags: tags,
      notaRelevancia: _notaRelevancia,
    );

    Navigator.pop(context, {'certificado': novo, 'index': widget.editIndex});
  }

  Widget _buildCover({required double width, double? height}) {
    final titulo = _tituloCtrl.text.trim().isEmpty
        ? 'Título do Certificado'
        : _tituloCtrl.text.trim();
    final inst = _instituicaoCtrl.text.trim().isEmpty
        ? 'Instituição'
        : _instituicaoCtrl.text.trim();
    final ano = _anoCtrl.text.trim().isEmpty ? 'Ano' : _anoCtrl.text.trim();

    final cor = _getColor();
    final icone = _getIcon();

    return Container(
      width: width,
      height: height ?? double.infinity,
      decoration: BoxDecoration(color: cor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: width < 150 ? 36 : 56, color: Colors.white70),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: width < 150 ? 14 : 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '$inst • $ano',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: width < 150 ? 10 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload simulado de PDF.')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Selecione um arquivo .pdf ou .jpg',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              'Máx 5MB',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isReadOnly, bool isEdicao) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            _Box(
              child: isReadOnly
                  ? Text(
                      _tituloCtrl.text,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )
                  : TextFormField(
                      controller: _tituloCtrl,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Título do Curso/Evento *',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Obrigatório'
                          : null,
                    ),
            ),
            const SizedBox(height: 12),
            _Box(
              child: isReadOnly
                  ? Text(
                      _instituicaoCtrl.text,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )
                  : TextFormField(
                      controller: _instituicaoCtrl,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Instituição Emissora *',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Obrigatório'
                          : null,
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Box(
                    child: isReadOnly
                        ? Text(
                            _tipoSelecionado,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        : DropdownButtonFormField<String>(
                            initialValue: _tipoSelecionado,
                            items: _tipos.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() => _tipoSelecionado = newValue);
                              }
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Curso',
                            ),
                            iconSize: 20,
                            isExpanded: true,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Box(
                    child: isReadOnly
                        ? Text(
                            _anoCtrl.text,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        : TextFormField(
                            controller: _anoCtrl,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Ano *',
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w700),
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
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'RELEVÂNCIA PROFISSIONAL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _notaRelevancia = index + 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      index < _notaRelevancia ? Icons.star : Icons.star_border,
                      color: const Color(0xFFF6B52E),
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
                  child: _Box(
                    child: isReadOnly
                        ? Text(
                            _cargaHorariaCtrl.text.isEmpty
                                ? 'N/A'
                                : _cargaHorariaCtrl.text,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        : TextFormField(
                            controller: _cargaHorariaCtrl,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Carga Horária (Opcional)',
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            keyboardType: TextInputType.number,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Box(
                    child: TextFormField(
                      controller: _tagsCtrl,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Tags (Ex: Web, API)',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isReadOnly)
              const _Box(
                title: 'IDENTIFICADOR DE SEGURANÇA',
                child: Text(
                  'SISPUBLI OFICIAL',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (!isReadOnly) ...[
              const Text(
                'COMPROVAÇÃO (EXCLUSÃO MÚTUA)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                ),
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
                    label: Text('Upload PDF'),
                    icon: Icon(Icons.upload_file),
                  ),
                ],
                selected: {_isLink},
                onSelectionChanged: (set) {
                  setState(() => _isLink = set.first);
                },
              ),
              const SizedBox(height: 12),
              if (_isLink)
                _Box(
                  title: 'LINK EXTERNO',
                  child: TextFormField(
                    controller: _linkCtrl,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'https://...',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (!_isLink) return null;
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe o link';
                      }
                      final uri = Uri.tryParse(v.trim());
                      if (uri == null || !uri.hasAuthority) {
                        return 'URL inválida';
                      }
                      return null;
                    },
                  ),
                )
              else
                _buildUploadBox(),
            ],
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: Text(isEdicao ? 'Salvar Edição' : 'SALVAR NOVO'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF355E3B,
                    ), // Dark green to match the screenshot "Salvar Documento (+50 XP)"
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar Link'),
                ),
                if (isReadOnly)
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('FECHAR'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.certificado != null;
    final isReadOnly = widget.certificado?.origem == Origem.sispubli;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text(
          isReadOnly
              ? 'Detalhes do Certificado'
              : (isEdicao ? 'Editar Certificado' : 'Registro Manual'),
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
                color: Colors.white,
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
                          _buildCover(width: double.infinity, height: 140),
                          _buildForm(isReadOnly, isEdicao),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCover(width: 220),
                          Expanded(
                            child: SingleChildScrollView(
                              child: _buildForm(isReadOnly, isEdicao),
                            ),
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

class _Box extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Box({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}
