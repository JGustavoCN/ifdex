import 'dart:typed_data';

import 'origem_enum.dart';

export 'origem_enum.dart';

/// Entidade central do sistema IFdex.
///
/// Representa um registro acadêmico (certificado, diploma ou
/// comprovante de atividade complementar) no portfólio digital
/// do usuário.
///
/// A instanciação **deve** ocorrer exclusivamente pelo Factory
/// [Certificado.criar], que valida todas as invariantes de
/// negócio antes de permitir a criação do objeto.
class Certificado {
  final String id;
  final Origem origem;
  String titulo;
  int ano;
  String instituicao;
  String tipoDescricao;
  int? cargaHoraria;
  String? urlDocumento;
  Uint8List? uploadDocumento;
  List<String> tags;
  int notaRelevancia;

  // ── Construtor privado ───────────────────────────────────
  Certificado._({
    required this.id,
    required this.origem,
    required this.titulo,
    required this.ano,
    required this.instituicao,
    required this.tipoDescricao,
    this.cargaHoraria,
    this.urlDocumento,
    this.uploadDocumento,
    required this.tags,
    required this.notaRelevancia,
  });

  // ── Factory: "O Porteiro" ────────────────────────────────
  /// Cria uma instância validada de [Certificado].
  ///
  /// Lança [ArgumentError] caso alguma invariante seja violada.
  factory Certificado.criar({
    required String id,
    required Origem origem,
    required String titulo,
    required int ano,
    required String instituicao,
    required String tipoDescricao,
    int? cargaHoraria,
    String? urlDocumento,
    Uint8List? uploadDocumento,
    required List<String> tags,
    required int notaRelevancia,
  }) {
    // 1. Validação de Título
    if (titulo.trim().isEmpty || titulo.length > 100) {
      throw ArgumentError(
        'O título é obrigatório e deve ter '
        'no máximo 100 caracteres.',
      );
    }

    // 2. Validação de Ano
    if (ano < 1900 || ano > 2026) {
      throw ArgumentError('O ano deve estar entre 1900 e 2026.');
    }

    // 3. Validação de Carga Horária
    if (cargaHoraria != null && (cargaHoraria < 1 || cargaHoraria > 5000)) {
      throw ArgumentError('A carga horária deve estar entre 1 e 5000.');
    }

    // 4. Exclusão Mútua (URL vs Upload)
    if (urlDocumento != null &&
        urlDocumento.isNotEmpty &&
        uploadDocumento != null) {
      throw ArgumentError('Forneça uma URL ou um Arquivo, não ambos.');
    }

    // 5. Validação de Nota de Relevância
    if (notaRelevancia < 1 || notaRelevancia > 5) {
      throw ArgumentError('A nota de relevância deve ser entre 1 e 5.');
    }

    // 6. Validação Básica de Strings (ID, Instituição, Tipo)
    if (id.trim().isEmpty ||
        instituicao.trim().isEmpty ||
        tipoDescricao.trim().isEmpty) {
      throw ArgumentError(
        'ID, Instituição e Tipo de Descrição '
        'não podem ser vazios.',
      );
    }

    // 7. Regras Específicas do Sispubli
    if (origem == Origem.sispubli) {
      if (instituicao.trim().toUpperCase() != 'IFS') {
        throw ArgumentError(
          'Certificados do Sispubli devem ter '
          'a instituição "IFS".',
        );
      }

      if (cargaHoraria != null) {
        throw ArgumentError(
          'Certificados do Sispubli não possuem '
          'carga horária (a API não fornece).',
        );
      }

      if (uploadDocumento != null) {
        throw ArgumentError(
          'Certificados do Sispubli não aceitam '
          'upload de arquivos, apenas URL permanente.',
        );
      }
    }

    // 8. Validação de Formato de URL (Básica)
    if (urlDocumento != null && urlDocumento.isNotEmpty) {
      final uri = Uri.tryParse(urlDocumento);
      if (uri == null || !uri.isAbsolute) {
        throw ArgumentError('A URL fornecida é inválida.');
      }
    }

    return Certificado._(
      id: id,
      origem: origem,
      titulo: titulo,
      ano: ano,
      instituicao: instituicao,
      tipoDescricao: tipoDescricao,
      cargaHoraria: cargaHoraria,
      urlDocumento: urlDocumento,
      uploadDocumento: uploadDocumento,
      tags: tags,
      notaRelevancia: notaRelevancia,
    );
  }
}
