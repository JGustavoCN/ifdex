// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sispubli_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$anosAtivosSispubliHash() =>
    r'32d36eaa4f0179d9596ed8072f2db6d80a94c1d8';

/// See also [anosAtivosSispubli].
@ProviderFor(anosAtivosSispubli)
final anosAtivosSispubliProvider = AutoDisposeProvider<Set<int>>.internal(
  anosAtivosSispubli,
  name: r'anosAtivosSispubliProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$anosAtivosSispubliHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnosAtivosSispubliRef = AutoDisposeProviderRef<Set<int>>;
String _$tiposAtivosSispubliHash() =>
    r'c9517f5c6a37106ecdbb35a4a802c58586b09e9a';

/// See also [tiposAtivosSispubli].
@ProviderFor(tiposAtivosSispubli)
final tiposAtivosSispubliProvider = AutoDisposeProvider<Set<String>>.internal(
  tiposAtivosSispubli,
  name: r'tiposAtivosSispubliProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tiposAtivosSispubliHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TiposAtivosSispubliRef = AutoDisposeProviderRef<Set<String>>;
String _$certificadosSispubliDisponiveisHash() =>
    r'afbc2c2d8b3637debf3775f3b5e6a5bb706c6add';

/// Provider Computado que atua como Filtro Inteligente.
/// Observa o estado do fetch da API e os dados locais do usuário,
/// retornando apenas os certificados do Sispubli que ainda não
/// foram salvos no cofre do IFdex.
///
/// Copied from [certificadosSispubliDisponiveis].
@ProviderFor(certificadosSispubliDisponiveis)
final certificadosSispubliDisponiveisProvider =
    AutoDisposeProvider<List<SispubliCertificadoDto>>.internal(
      certificadosSispubliDisponiveis,
      name: r'certificadosSispubliDisponiveisProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$certificadosSispubliDisponiveisHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CertificadosSispubliDisponiveisRef =
    AutoDisposeProviderRef<List<SispubliCertificadoDto>>;
String _$filtroSispubliNotifierHash() =>
    r'79542888cf2d792b07259205b8c17716a45f331c';

/// See also [FiltroSispubliNotifier].
@ProviderFor(FiltroSispubliNotifier)
final filtroSispubliNotifierProvider =
    AutoDisposeNotifierProvider<
      FiltroSispubliNotifier,
      FiltrosSispubli
    >.internal(
      FiltroSispubliNotifier.new,
      name: r'filtroSispubliNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filtroSispubliNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FiltroSispubliNotifier = AutoDisposeNotifier<FiltrosSispubli>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
