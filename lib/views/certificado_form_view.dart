import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/certificado.dart';
import '../widgets/app_text.dart';

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
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _instituicaoCtrl.dispose();
    _anoCtrl.dispose();
    _cargaHorariaCtrl.dispose();
    _tagsCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String? url;
    String? upload;

    if (_isLink) {
      url = _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim();
    } else {
      upload = 'arquivo_local_simulado.pdf';
    }

    final novo = Certificado(
      id: widget.certificado?.id ?? const Uuid().v4(),
      origem: widget.certificado?.origem ?? Origem.manual,
      titulo: _tituloCtrl.text.trim(),
      ano: int.tryParse(_anoCtrl.text.trim()) ?? DateTime.now().year,
      instituicao: _instituicaoCtrl.text.trim(),
      tipoDescricao: 'Manual',
      cargaHoraria: int.tryParse(_cargaHorariaCtrl.text.trim()),
      urlDocumento: url,
      uploadDocumento: upload,
      tags: tags,
    );

    Navigator.pop(context, {'certificado': novo, 'index': widget.editIndex});
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.certificado != null;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Certificado' : 'Registro Manual'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width > 700 ? 480 : double.infinity,
            ),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const AppText(
                          'Registro Manual',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF355E3B),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tituloCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Título do Curso/Evento *',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Título obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _instituicaoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Instituição Emissora *',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Instituição obrigatória'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _anoCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Curso',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Ano obrigatório';
                              }
                              final ano = int.tryParse(v.trim());
                              final atual = DateTime.now().year;
                              if (ano == null || ano < 1900 || ano > atual) {
                                return 'Ano inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cargaHorariaCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Carga Horária',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tagsCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tags (Ex: Web, API)',
                        hintText: 'Separe por vírgulas',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'COMPROVAÇÃO (EXCLUSÃO MÚTUA)',
                      style: TextStyle(
                        fontSize: 12,
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
                      TextFormField(
                        controller: _linkCtrl,
                        decoration: const InputDecoration(
                          hintText: 'https://...',
                        ),
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
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Upload simulado de PDF.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Selecionar arquivo'),
                      ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: _salvar,
                      child: Text(
                        isEdicao
                            ? 'Atualizar Certificado'
                            : 'Salvar Documento (+50 XP)',
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
