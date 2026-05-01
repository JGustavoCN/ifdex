enum Origem { sispubli, manual }

class Certificado {
  final String id;
  final Origem origem;
  String titulo;
  int ano;
  String instituicao;
  String tipoDescricao;
  int notaRelevancia;
  int? cargaHoraria;
  String? urlDocumento;
  String? uploadDocumento;
  List<String> tags;

  Certificado({
    required this.id,
    required this.origem,
    required this.titulo,
    required this.ano,
    required this.instituicao,
    this.tipoDescricao = '',
    this.cargaHoraria,
    this.urlDocumento,
    this.uploadDocumento,
    this.tags = const [],
    this.notaRelevancia = 1,
  });
}