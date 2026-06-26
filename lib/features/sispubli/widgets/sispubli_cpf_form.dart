import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/features/sispubli/presentation/sispubli_import_view_model.dart';
import 'package:ifdex/shared/theme/app_theme.dart';
import 'package:ifdex/shared/widgets/app_text.dart';

/// Fase 1: Formulário isolado para coletar o CPF.
class SispubliCpfForm extends ConsumerStatefulWidget {
  const SispubliCpfForm({super.key});

  @override
  ConsumerState<SispubliCpfForm> createState() => _SispubliCpfFormState();
}

class _SispubliCpfFormState extends ConsumerState<SispubliCpfForm> {
  final _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _buscar() {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cpfLimpo = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    ref
        .read(sispubliImportViewModelProvider.notifier)
        .buscarCertificados(cpfLimpo);

    // Reset para o caso da árvore não ser desmontada imediatamente (delay)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(
                    'assets/logo_ifs.svg',
                    width: 48,
                    height: 48,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppText.headline('Importar Certificados'),
                const SizedBox(height: 8),
                const AppText(
                  'Busque seus certificados oficiais '
                  'registrados no Sispubli do IFS.',
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: '00000000000',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (value) {
                    final limpo = (value ?? '').replaceAll(RegExp(r'\D'), '');
                    if (limpo.length != 11) {
                      return 'Informe os 11 dígitos do CPF.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _buscar(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _buscar,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : const Icon(Icons.search, size: 20),
                    label: AppText(
                      _isLoading ? 'Buscando...' : 'Buscar Certificados',
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.infoSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: AppColors.info),
                      SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          'Seu CPF não será armazenado. '
                          'Usado apenas para consulta.',
                          fontSize: 12,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
