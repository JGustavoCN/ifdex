import 'package:flutter/material.dart';
import '../data/mock_certificados.dart';
import '../models/certificado.dart';
import '../widgets/certificado_card.dart';
import '../widgets/xp_header.dart';
import 'certificado_form_view.dart';
import 'certificado_detalhes_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Certificado> certificados = List.from(certificadosMock);
  int xp = 150;
  String filtroAtual = 'todos';

List<Certificado> get certificadosFiltrados {
  if (filtroAtual == 'oficial') {
    return certificados
        .where((c) => c.origem == Origem.sispubli)
        .toList();
  }

  if (filtroAtual == 'manual') {
    return certificados
        .where((c) => c.origem == Origem.manual)
        .toList();
  }

  return certificados;
}

  void _removerCertificado(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar remoção'),
        content: const Text('Tem certeza que deseja remover este certificado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                certificados.removeAt(index);
                xp = (xp - 50).clamp(0, 99999);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificado removido.')),
              );
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirFormulario([Certificado? certificado, int? index]) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => CertificadoFormView(certificado: certificado, editIndex: index),
      ),
    );

    if (resultado == null || !mounted) return;

    final ehEdicao = resultado['index'] != null;
    final novoCert = resultado['certificado'] as Certificado;

    setState(() {
      if (ehEdicao) {
        certificados[resultado['index'] as int] = novoCert;
      } else {
        certificados.add(novoCert);
        xp += 50;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ehEdicao ? 'Certificado atualizado.' : 'Certificado salvo com sucesso!')),
    );
  }

  void _abrirDetalhes(Certificado certificado, int index) {
  showDialog(
    context: context,
    builder: (_) => CertificadoDetalhesDialog(
      certificado: certificado,
      onEdit: certificado.origem == Origem.manual
          ? () {
              Navigator.pop(context);
              _abrirFormulario(certificado, index);
            }
          : null,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: null,
      body: Column(
        children: [
          XpHeader(totalCertificados: certificados.length, xp: xp),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PORTFÓLIO',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF6B7280)),
                ),
                PopupMenuButton<String>(
  onSelected: (value) {
    setState(() {
      filtroAtual = value;
    });
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'todos',
      child: Text('Todos'),
    ),
    const PopupMenuItem(
      value: 'oficial',
      child: Text('Oficiais'),
    ),
    const PopupMenuItem(
      value: 'manual',
      child: Text('Manuais'),
    ),
  ],
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE5E7EB),
      ),
    ),
    child: Row(
      children: const [
        Icon(Icons.filter_alt_outlined, size: 18),
        SizedBox(width: 6),
        Text(
          'Filtrar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
)
              ],
            ),
          ),
          Expanded(
            child: certificados.isEmpty
                ? const Center(child: Text('Nenhum certificado cadastrado.'))
                : ListView.builder(
                    itemCount: certificadosFiltrados.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final c = certificadosFiltrados[index];
                      return CertificadoCard(
                        certificado: c,
                        onTap: () => _abrirDetalhes(c, index),
                        onRemove: () => _removerCertificado(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () => _abrirFormulario(),
  backgroundColor: const Color(0xFF355E3B),
  foregroundColor: Colors.white,
  child: const Icon(Icons.add),
),
    );
  }
}