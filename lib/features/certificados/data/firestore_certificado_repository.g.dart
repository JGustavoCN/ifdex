// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_certificado_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreCertificadoRepositoryHash() =>
    r'8bd37b0076e1e8382c08367739115d26796d94f0';

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

/// See also [firestoreCertificadoRepository].
@ProviderFor(firestoreCertificadoRepository)
const firestoreCertificadoRepositoryProvider =
    FirestoreCertificadoRepositoryFamily();

/// See also [firestoreCertificadoRepository].
class FirestoreCertificadoRepositoryFamily
    extends Family<FirestoreCertificadoRepository> {
  /// See also [firestoreCertificadoRepository].
  const FirestoreCertificadoRepositoryFamily();

  /// See also [firestoreCertificadoRepository].
  FirestoreCertificadoRepositoryProvider call(String uid) {
    return FirestoreCertificadoRepositoryProvider(uid);
  }

  @override
  FirestoreCertificadoRepositoryProvider getProviderOverride(
    covariant FirestoreCertificadoRepositoryProvider provider,
  ) {
    return call(provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'firestoreCertificadoRepositoryProvider';
}

/// See also [firestoreCertificadoRepository].
class FirestoreCertificadoRepositoryProvider
    extends AutoDisposeProvider<FirestoreCertificadoRepository> {
  /// See also [firestoreCertificadoRepository].
  FirestoreCertificadoRepositoryProvider(String uid)
    : this._internal(
        (ref) => firestoreCertificadoRepository(
          ref as FirestoreCertificadoRepositoryRef,
          uid,
        ),
        from: firestoreCertificadoRepositoryProvider,
        name: r'firestoreCertificadoRepositoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$firestoreCertificadoRepositoryHash,
        dependencies: FirestoreCertificadoRepositoryFamily._dependencies,
        allTransitiveDependencies:
            FirestoreCertificadoRepositoryFamily._allTransitiveDependencies,
        uid: uid,
      );

  FirestoreCertificadoRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FirestoreCertificadoRepository Function(
      FirestoreCertificadoRepositoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirestoreCertificadoRepositoryProvider._internal(
        (ref) => create(ref as FirestoreCertificadoRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FirestoreCertificadoRepository> createElement() {
    return _FirestoreCertificadoRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirestoreCertificadoRepositoryProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FirestoreCertificadoRepositoryRef
    on AutoDisposeProviderRef<FirestoreCertificadoRepository> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _FirestoreCertificadoRepositoryProviderElement
    extends AutoDisposeProviderElement<FirestoreCertificadoRepository>
    with FirestoreCertificadoRepositoryRef {
  _FirestoreCertificadoRepositoryProviderElement(super.provider);

  @override
  String get uid => (origin as FirestoreCertificadoRepositoryProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
