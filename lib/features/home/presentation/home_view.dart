import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';
import 'package:ifdex/features/certificados/presentation/certificado_form_view.dart';
import 'package:ifdex/features/sispubli/presentation/sispubli_import_view.dart';
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
      floatingActionButton: isMobile ? const _SpeedDialFab() : null,
    );
  }
}

// ── SpeedDial FAB (Mobile Only) ─────────────────────

class _SpeedDialFab extends StatefulWidget {
  const _SpeedDialFab();

  @override
  State<_SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<_SpeedDialFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _navegar(Widget destino) {
    _toggle();
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => destino));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Mini-FABs
        FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MiniAction(
                  icon: Icons.cloud_download_outlined,
                  label: 'Importar do IFS',
                  onTap: () => _navegar(const SispubliImportView()),
                ),
                const SizedBox(height: 12),
                _MiniAction(
                  icon: Icons.edit_note,
                  label: 'Digitar Manualmente',
                  onTap: () => _navegar(const CertificadoFormView()),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // FAB principal
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// ── Mini-FAB com label ──────────────────────────────

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppColors.surface,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          heroTag: label,
          onPressed: onTap,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: 2,
          child: Icon(icon, size: 20),
        ),
      ],
    );
  }
}
