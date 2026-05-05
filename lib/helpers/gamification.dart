/// Encapsula toda a lógica de gamificação do IFdex.
///
/// O XP total é **computado** a partir da quantidade de
/// certificados em memória (`quantidade * 50`), eliminando
/// qualquer risco de dessincronização de estado.
class Gamification {
  /// Quantidade de certificados na lista em memória.
  final int totalCertificados;

  const Gamification(this.totalCertificados);

  // ── XP ──────────────────────────────────────────────

  /// XP total = certificados × 50.
  int get totalXp => totalCertificados * 50;

  // ── Níveis (curva exponencial) ──────────────────────

  /// Tabela fixa de progressão.
  ///
  /// Cada entrada: `[xpBase, xpTarget, nível, nome]`
  ///
  /// Delta entre níveis **dobra** a cada transição:
  ///   Lvl 1 → 2: delta 100  (base)
  ///   Lvl 2 → 3: delta 200  (100 × 2)
  ///   Lvl 3 → 4: delta 400  (200 × 2)
  ///   Lvl 4 → 5: delta 800  (400 × 2)
  static const _niveis = [
    {'base': 0, 'target': 100, 'nivel': 1, 'nome': 'Calouro'},
    {'base': 100, 'target': 300, 'nivel': 2, 'nome': 'Explorador'},
    {'base': 300, 'target': 700, 'nivel': 3, 'nome': 'Especialista'},
    {'base': 700, 'target': 1500, 'nivel': 4, 'nome': 'Mestre'},
    {'base': 1500, 'target': 1500, 'nivel': 5, 'nome': 'Lenda'},
  ];

  /// Retorna o mapa do nível atual com base no [totalXp].
  Map<String, dynamic> get _nivelAtual {
    for (var i = 0; i < _niveis.length - 1; i++) {
      if (totalXp < (_niveis[i]['target'] as int)) {
        return _niveis[i];
      }
    }
    return _niveis.last;
  }

  /// Nível numérico atual (1–5).
  int get nivel => _nivelAtual['nivel'] as int;

  /// Nome legível do nível (ex: "Calouro").
  String get nomeNivel => _nivelAtual['nome'] as String;

  /// XP base do nível atual (para cálculo do progresso).
  int get xpBase => _nivelAtual['base'] as int;

  /// XP necessário para subir de nível.
  int get xpTarget => _nivelAtual['target'] as int;

  // ── Progresso ──────────────────────────────────────

  /// XP restante para o próximo nível. Zero se já for Lenda.
  int get xpRestante {
    if (nivel == 5) return 0;
    return xpTarget - totalXp;
  }

  /// Progresso decimal (0.0 a 1.0) **dentro do nível**.
  ///
  /// No nível máximo (Lenda) retorna 1.0.
  double get progressoPercent {
    if (nivel == 5) return 1.0;
    final range = xpTarget - xpBase;
    if (range <= 0) return 1.0;
    return ((totalXp - xpBase) / range).clamp(0.0, 1.0);
  }
}
