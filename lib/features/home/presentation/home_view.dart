import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/features/certificados/presentation/certificado_form_view.dart';
import 'package:ifdex/features/auth/widgets/auth_status_widget.dart';
import 'home_mobile_view.dart';
import 'home_web_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.surface,
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo_transparent.png',
                            height: 64,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'IFdex',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const AuthStatusWidget(),
                ],
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return const HomeMobileView();
          }

          return const HomeWebView();
        },
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const CertificadoFormView(),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
