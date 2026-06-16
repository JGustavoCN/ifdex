import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider \'${provider.name ?? provider.runtimeType}\' initialized',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider \'${provider.name ?? provider.runtimeType}\' updated: '
      '$previousValue -> $newValue',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider \'${provider.name ?? provider.runtimeType}\' disposed',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider \'${provider.name ?? provider.runtimeType}\' failed: $error',
    );
  }
}
