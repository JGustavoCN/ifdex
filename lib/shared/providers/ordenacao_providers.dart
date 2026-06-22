import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ifdex/shared/models/ordenacao_enum.dart';

part 'ordenacao_providers.g.dart';

@riverpod
class OrdenacaoHomeState extends _$OrdenacaoHomeState {
  @override
  OrdenacaoHome build() => OrdenacaoHome.anoDesc;

  void setOrdem(OrdenacaoHome novaOrdem) => state = novaOrdem;
}

@riverpod
class OrdenacaoSispubliState extends _$OrdenacaoSispubliState {
  @override
  OrdenacaoSispubli build() => OrdenacaoSispubli.anoDesc;

  void setOrdem(OrdenacaoSispubli novaOrdem) => state = novaOrdem;
}
