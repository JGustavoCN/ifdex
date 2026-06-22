// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busca_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buscaHomeHash() => r'ec39cde4a4ce566e308e50d5f6096079cfb9e699';

/// Estado global em tempo real (1:1 com a digitação do teclado)
///
/// Copied from [BuscaHome].
@ProviderFor(BuscaHome)
final buscaHomeProvider =
    AutoDisposeNotifierProvider<BuscaHome, String>.internal(
      BuscaHome.new,
      name: r'buscaHomeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buscaHomeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuscaHome = AutoDisposeNotifier<String>;
String _$buscaHomeDebouncedHash() =>
    r'590ff74cd5f5fc5fdabdb31baa81f65f2ca90563';

/// Estado com Debounce (Atraso de 300ms) - Síncrono
///
/// Copied from [BuscaHomeDebounced].
@ProviderFor(BuscaHomeDebounced)
final buscaHomeDebouncedProvider =
    AutoDisposeNotifierProvider<BuscaHomeDebounced, String>.internal(
      BuscaHomeDebounced.new,
      name: r'buscaHomeDebouncedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buscaHomeDebouncedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuscaHomeDebounced = AutoDisposeNotifier<String>;
String _$buscaSispubliHash() => r'05f385018e6f3b748c18a760d95bf477b53f6b55';

/// Estado global em tempo real
///
/// Copied from [BuscaSispubli].
@ProviderFor(BuscaSispubli)
final buscaSispubliProvider =
    AutoDisposeNotifierProvider<BuscaSispubli, String>.internal(
      BuscaSispubli.new,
      name: r'buscaSispubliProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buscaSispubliHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuscaSispubli = AutoDisposeNotifier<String>;
String _$buscaSispubliDebouncedHash() =>
    r'2e7acbd4077eab3c38f421705c7a3a23e184aad6';

/// Estado com Debounce para o Sispubli (Atraso de 300ms)
///
/// Copied from [BuscaSispubliDebounced].
@ProviderFor(BuscaSispubliDebounced)
final buscaSispubliDebouncedProvider =
    AutoDisposeNotifierProvider<BuscaSispubliDebounced, String>.internal(
      BuscaSispubliDebounced.new,
      name: r'buscaSispubliDebouncedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buscaSispubliDebouncedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuscaSispubliDebounced = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
