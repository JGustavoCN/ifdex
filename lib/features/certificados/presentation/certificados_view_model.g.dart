// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificados_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$instituicoesAtivasHash() =>
    r'18a3ca577b63365f990ac2f3ecbb594649895f16';

/// See also [instituicoesAtivas].
@ProviderFor(instituicoesAtivas)
final instituicoesAtivasProvider = AutoDisposeProvider<Set<String>>.internal(
  instituicoesAtivas,
  name: r'instituicoesAtivasProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$instituicoesAtivasHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InstituicoesAtivasRef = AutoDisposeProviderRef<Set<String>>;
String _$anosAtivosHash() => r'd90acd1aa4ce079775e7da344eeac48f1990dc7e';

/// See also [anosAtivos].
@ProviderFor(anosAtivos)
final anosAtivosProvider = AutoDisposeProvider<Set<int>>.internal(
  anosAtivos,
  name: r'anosAtivosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$anosAtivosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnosAtivosRef = AutoDisposeProviderRef<Set<int>>;
String _$tiposAtivosHash() => r'a2d9b56185d75fbd6815f7daef5b844a7d8bbd85';

/// See also [tiposAtivos].
@ProviderFor(tiposAtivos)
final tiposAtivosProvider = AutoDisposeProvider<Set<String>>.internal(
  tiposAtivos,
  name: r'tiposAtivosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tiposAtivosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TiposAtivosRef = AutoDisposeProviderRef<Set<String>>;
String _$tagsAtivasHash() => r'b9d3882d34ac31713305f866c408086841512393';

/// See also [tagsAtivas].
@ProviderFor(tagsAtivas)
final tagsAtivasProvider = AutoDisposeProvider<Set<String>>.internal(
  tagsAtivas,
  name: r'tagsAtivasProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagsAtivasHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagsAtivasRef = AutoDisposeProviderRef<Set<String>>;
String _$certificadosFiltradosHash() =>
    r'3ab391f4b13e6201f40d512f5e4bf7c2b205160a';

/// See also [certificadosFiltrados].
@ProviderFor(certificadosFiltrados)
final certificadosFiltradosProvider =
    AutoDisposeProvider<List<Certificado>>.internal(
      certificadosFiltrados,
      name: r'certificadosFiltradosProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$certificadosFiltradosHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CertificadosFiltradosRef = AutoDisposeProviderRef<List<Certificado>>;
String _$certificadoPorIdHash() => r'4e65f71dbd963a7027740ba07396729940b579b5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [certificadoPorId].
@ProviderFor(certificadoPorId)
const certificadoPorIdProvider = CertificadoPorIdFamily();

/// See also [certificadoPorId].
class CertificadoPorIdFamily extends Family<Certificado?> {
  /// See also [certificadoPorId].
  const CertificadoPorIdFamily();

  /// See also [certificadoPorId].
  CertificadoPorIdProvider call(String id) {
    return CertificadoPorIdProvider(id);
  }

  @override
  CertificadoPorIdProvider getProviderOverride(
    covariant CertificadoPorIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'certificadoPorIdProvider';
}

/// See also [certificadoPorId].
class CertificadoPorIdProvider extends AutoDisposeProvider<Certificado?> {
  /// See also [certificadoPorId].
  CertificadoPorIdProvider(String id)
    : this._internal(
        (ref) => certificadoPorId(ref as CertificadoPorIdRef, id),
        from: certificadoPorIdProvider,
        name: r'certificadoPorIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$certificadoPorIdHash,
        dependencies: CertificadoPorIdFamily._dependencies,
        allTransitiveDependencies:
            CertificadoPorIdFamily._allTransitiveDependencies,
        id: id,
      );

  CertificadoPorIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Certificado? Function(CertificadoPorIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CertificadoPorIdProvider._internal(
        (ref) => create(ref as CertificadoPorIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Certificado?> createElement() {
    return _CertificadoPorIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CertificadoPorIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CertificadoPorIdRef on AutoDisposeProviderRef<Certificado?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CertificadoPorIdProviderElement
    extends AutoDisposeProviderElement<Certificado?>
    with CertificadoPorIdRef {
  _CertificadoPorIdProviderElement(super.provider);

  @override
  String get id => (origin as CertificadoPorIdProvider).id;
}

String _$filtroCertificadosHash() =>
    r'034e9e45a721af74a14f1092228caca5004d1364';

/// See also [FiltroCertificados].
@ProviderFor(FiltroCertificados)
final filtroCertificadosProvider =
    AutoDisposeNotifierProvider<FiltroCertificados, FiltrosGlobais>.internal(
      FiltroCertificados.new,
      name: r'filtroCertificadosProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filtroCertificadosHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FiltroCertificados = AutoDisposeNotifier<FiltrosGlobais>;
String _$certificadosViewModelHash() =>
    r'9a0a8967d1fc0410c7644767f736566261860a66';

/// See also [CertificadosViewModel].
@ProviderFor(CertificadosViewModel)
final certificadosViewModelProvider =
    AutoDisposeAsyncNotifierProvider<
      CertificadosViewModel,
      List<Certificado>
    >.internal(
      CertificadosViewModel.new,
      name: r'certificadosViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$certificadosViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CertificadosViewModel = AutoDisposeAsyncNotifier<List<Certificado>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
