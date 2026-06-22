import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _buscar() {
    if (!_formKey.currentState!.validate()) return;

    final cpfLimpo = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    ref
        .read(sispubliImportViewModelProvider.notifier)
        .buscarCertificados(cpfLimpo);
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
                  child: const Icon(
                    Icons.account_balance,
                    size: 48,
                    color: AppColors.primary,
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
                    onPressed: _buscar,
                    icon: const Icon(Icons.search, size: 20),
                    label: const AppText(
                      'Buscar Certificados',
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
