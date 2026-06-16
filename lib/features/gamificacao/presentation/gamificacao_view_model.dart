import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/gamificacao/models/gamification.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';

part 'gamificacao_view_model.g.dart';

@riverpod
Gamification gamificacaoViewModel(GamificacaoViewModelRef ref) {
  // Observamos estritamente a quantidade de certificados para não refazer
  // o cálculo à toa se outras propriedades de um certificado mudarem.
  final quantidade = ref.watch(
    certificadosViewModelProvider.select((state) => state.value?.length ?? 0),
  );

  return Gamification(quantidade);
}
