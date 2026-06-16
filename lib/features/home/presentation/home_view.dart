import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/features/certificados/presentation/certificado_form_view.dart';
import 'home_mobile_view.dart';
import 'home_web_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
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
