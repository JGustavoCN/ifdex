enum OrdenacaoHome {
  anoDesc('Ano: Mais Recente'),
  anoAsc('Ano: Mais Antigo'),
  relevanciaDesc('Maior Relevância'),
  cargaHorariaDesc('Maior Carga Horária'),
  tituloAsc('Título (A-Z)'),
  tituloDesc('Título (Z-A)');

  final String label;
  const OrdenacaoHome(this.label);
}

enum OrdenacaoSispubli {
  anoDesc('Ano: Mais Recente'),
  anoAsc('Ano: Mais Antigo'),
  tituloAsc('Título (A-Z)'),
  tituloDesc('Título (Z-A)');

  final String label;
  const OrdenacaoSispubli(this.label);
}
