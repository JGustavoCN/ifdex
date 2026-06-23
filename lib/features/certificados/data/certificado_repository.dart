import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/auth/data/current_uid_provider.dart';
import 'package:ifdex/features/certificados/data/certificado_arquivo_datasource.dart';
import 'package:ifdex/features/certificados/data/certificado_firestore_datasource.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

part 'certificado_repository.g.dart';

@riverpod
CertificadoRepository certificadoRepository(CertificadoRepositoryRef ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    throw Exception('Usuário não autenticado');
  }
  return CertificadoRepository(
    uid,
    ref.read(certificadoFirestoreDatasourceProvider),
    ref.read(certificadoArquivoDatasourceProvider),
  );
}

/// Repositório concreto que implementa a orquestração de 2 coleções no Firestore.
class CertificadoRepository {
  final String _uid;
  final CertificadoFirestoreDatasource _firestoreDatasource;
  final CertificadoArquivoDatasource _arquivoDatasource;

  CertificadoRepository(
    this._uid,
    this._firestoreDatasource,
    this._arquivoDatasource,
  );

  /// Lista todos os metadados dos certificados.
  Future<List<Certificado>> listarTodos() async {
    return _firestoreDatasource.listarTodos(_uid);
  }

  /// Adiciona ou edita um certificado.
  /// Lida com o upload do arquivo binário na segunda coleção, se houver.
  Future<void> adicionar(Certificado certificado, {String? fileName}) async {
    // Se há um arquivo transitório, tenta fazer o upload na segunda coleção
    if (certificado.uploadDocumento != null && fileName != null) {
      final ext = await _arquivoDatasource.uploadArquivo(
        _uid,
        certificado.id,
        certificado.uploadDocumento!,
        fileName,
      );
      certificado.temArquivo = true;
      certificado.formatoArquivo = ext;
    }

    // Salva metadados (note que uploadDocumento não é salvo no toMap)
    await _firestoreDatasource.salvar(_uid, certificado);
  }

  /// Faz o download do binário atrelado a este certificado.
  Future<Uint8List?> carregarArquivo(Certificado certificado) async {
    return _arquivoDatasource.downloadArquivo(
      _uid,
      certificado.id,
      certificado.formatoArquivo,
    );
  }

  /// Retorna uma URL assinada válida por 60 segundos para consumo via streaming.
  Future<String?> obterUrlAssinada(Certificado certificado) async {
    return _arquivoDatasource.obterUrlAssinada(
      _uid,
      certificado.id,
      certificado.formatoArquivo,
    );
  }

  /// Remove o certificado e seu arquivo binário (se existir).
  Future<void> remover(Certificado certificado) async {
    await _firestoreDatasource.remover(_uid, certificado.id);
    // Tenta deletar o arquivo sem se importar se havia ou não
    await _arquivoDatasource.removerArquivo(
      _uid,
      certificado.id,
      certificado.formatoArquivo,
    );
  }
}
