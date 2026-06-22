class FiltrosGlobais {
  final Set<String> instituicoesSelecionadas;
  final Set<int> estrelasSelecionadas;
  final int? minAno;
  final int? maxAno;
  final Set<String> tiposSelecionados;
  final Set<String> tagsSelecionadas;
  final int minCargaHoraria;
  final int maxCargaHoraria;
  final String origemSelecionada;

  const FiltrosGlobais({
    this.instituicoesSelecionadas = const {},
    this.estrelasSelecionadas = const {},
    this.minAno,
    this.maxAno,
    this.tiposSelecionados = const {},
    this.tagsSelecionadas = const {},
    this.minCargaHoraria = 0,
    this.maxCargaHoraria = 5000,
    this.origemSelecionada = 'todos',
  });

  FiltrosGlobais copyWith({
    Set<String>? instituicoesSelecionadas,
    Set<int>? estrelasSelecionadas,
    int? minAno,
    int? maxAno,
    Set<String>? tiposSelecionados,
    Set<String>? tagsSelecionadas,
    int? minCargaHoraria,
    int? maxCargaHoraria,
    String? origemSelecionada,
  }) {
    return FiltrosGlobais(
      instituicoesSelecionadas:
          instituicoesSelecionadas ?? this.instituicoesSelecionadas,
      estrelasSelecionadas: estrelasSelecionadas ?? this.estrelasSelecionadas,
      minAno: minAno ?? this.minAno,
      maxAno: maxAno ?? this.maxAno,
      tiposSelecionados: tiposSelecionados ?? this.tiposSelecionados,
      tagsSelecionadas: tagsSelecionadas ?? this.tagsSelecionadas,
      minCargaHoraria: minCargaHoraria ?? this.minCargaHoraria,
      maxCargaHoraria: maxCargaHoraria ?? this.maxCargaHoraria,
      origemSelecionada: origemSelecionada ?? this.origemSelecionada,
    );
  }

  bool get isEmpty =>
      instituicoesSelecionadas.isEmpty &&
      estrelasSelecionadas.isEmpty &&
      minAno == null &&
      maxAno == null &&
      tiposSelecionados.isEmpty &&
      tagsSelecionadas.isEmpty &&
      minCargaHoraria == 0 &&
      maxCargaHoraria == 5000 &&
      origemSelecionada == 'todos';
}
