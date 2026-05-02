import 'package:flutter/material.dart';

import '../data/mock_certificados.dart';
import '../models/certificado.dart';
import '../theme/app_theme.dart';
import 'certificado_form_view.dart';
import 'home_mobile_view.dart';
import 'home_web_view.dart';

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
      return certificados.where((c) => c.origem == Origem.sispubli).toList();
    }

    if (filtroAtual == 'manual') {
      return certificados.where((c) => c.origem == Origem.manual).toList();
    }

    return certificados;
  }

  void _removerCertificado(int index) {
    setState(() {
      certificados.removeAt(index);
      xp = (xp - 50).clamp(0, 99999);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Certificado removido.')));
  }

  Future<void> _abrirFormulario([Certificado? certificado, int? index]) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CertificadoFormView(certificado: certificado, editIndex: index),
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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ehEdicao
              ? 'Certificado atualizado.'
              : 'Certificado salvo com sucesso!',
        ),
      ),
    );
  }

  void _abrirDetalhes(Certificado certificado, int index) {
    _abrirFormulario(certificado, index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return HomeMobileView(
              certificadosFiltrados: certificadosFiltrados,
              totalCertificados: certificados.length,
              xp: xp,
              filtroAtual: filtroAtual,
              onFiltroChanged: (valor) {
                setState(() => filtroAtual = valor);
              },
              onAdicionarCertificado: _abrirFormulario,
              onAbrirDetalhes: _abrirDetalhes,
              onRemoverCertificado: _removerCertificado,
            );
          }

          return HomeWebView(
            certificadosFiltrados: certificadosFiltrados,
            totalCertificados: certificados.length,
            xp: xp,
            filtroAtual: filtroAtual,
            onFiltroChanged: (valor) {
              setState(() => filtroAtual = valor);
            },
            onAdicionarCertificado: _abrirFormulario,
            onAbrirDetalhes: _abrirDetalhes,
            onRemoverCertificado: _removerCertificado,
          );
        },
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: _abrirFormulario,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
