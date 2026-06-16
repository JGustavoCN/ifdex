import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/features/certificados/data/mock_certificado_repository.dart';

part 'certificado_repository.g.dart';

abstract interface class CertificadoRepository {
  Future<List<Certificado>> listar();

  Future<void> adicionar(Certificado certificado);

  Future<void> atualizar(Certificado certificado);

  Future<void> remover(String id);
}

@riverpod
CertificadoRepository certificadoRepository(CertificadoRepositoryRef ref) {
  return MockCertificadoRepository();
}
