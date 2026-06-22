class FiltrosSispubli {
  final int? minAno;
  final int? maxAno;
  final Set<String> tiposSelecionados;

  const FiltrosSispubli({
    this.minAno,
    this.maxAno,
    this.tiposSelecionados = const {},
  });

  FiltrosSispubli copyWith({
    int? minAno,
    int? maxAno,
    Set<String>? tiposSelecionados,
  }) {
    return FiltrosSispubli(
      minAno: minAno ?? this.minAno,
      maxAno: maxAno ?? this.maxAno,
      tiposSelecionados: tiposSelecionados ?? this.tiposSelecionados,
    );
  }

  bool get isEmpty =>
      minAno == null && maxAno == null && tiposSelecionados.isEmpty;
}
