import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/certificados/data/firestore_certificado_repository.dart';
import 'package:ifdex/features/auth/data/current_uid_provider.dart';

part 'certificado_repository.g.dart';

@riverpod
FirestoreCertificadoRepository certificadoRepository(
  CertificadoRepositoryRef ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    throw Exception('Usuário não autenticado');
  }
  return ref.watch(firestoreCertificadoRepositoryProvider(uid));
}
