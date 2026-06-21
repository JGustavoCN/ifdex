import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifdex/features/auth/presentation/auth_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

class AuthGate extends ConsumerWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authViewModelProvider, (previous, next) {
      final user = next.valueOrNull;
      if (next is AsyncData && user == null) {
        // Automatically sign in anonymously when user is null
        ref.read(authViewModelProvider.notifier).signInAnonymously();
      }
    });

    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return _buildSplash(); // Espera o listener logar
        }
        return child;
      },
      loading: () => _buildSplash(),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              AppText.body(
                'Erro ao inicializar autenticação',
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(authViewModelProvider.notifier)
                    .signInAnonymously(),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            AppText.headline('IFdex', color: AppColors.primary),
            const SizedBox(height: 8),
            AppText.body(
              'Cofre de Certificados',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
