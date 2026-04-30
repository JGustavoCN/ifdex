class Gamification {
  final int xp;

  const Gamification(this.xp);

  int get nivel {
    if (xp < 50) return 1;
    if (xp < 150) return 2;
    if (xp < 350) return 3;
    return 4;
  }

  String get nomeNivel {
    switch (nivel) {
      case 1: return 'Calouro';
      case 2: return 'Explorador';
      case 3: return 'Especialista';
      default: return 'Veterano';
    }
  }

  int get xpNivelAnterior {
    switch (nivel) {
      case 1: return 0;
      case 2: return 50;
      case 3: return 150;
      default: return 350;
    }
  }

  int get xpProximoNivel {
    if (nivel == 1) return 50;
    if (nivel == 2) return 150;
    if (nivel == 3) return 350;
    return 9999; // nível máximo
  }

  int get xpRestante => xpProximoNivel - xp;
  double get progressoPercent =>
      (xp - xpNivelAnterior) / (xpProximoNivel - xpNivelAnterior);
}