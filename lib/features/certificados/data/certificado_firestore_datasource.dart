import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'certificado_firestore_datasource.g.dart';

@riverpod
CertificadoFirestoreDatasource certificadoFirestoreDatasource(
  CertificadoFirestoreDatasourceRef ref,
) {
  return CertificadoFirestoreDatasource(FirebaseFirestore.instance);
}

/// Datasource responsável pelas operações CRUD de metadados no Firestore.
class CertificadoFirestoreDatasource {
  final FirebaseFirestore _db;

  CertificadoFirestoreDatasource(this._db);

  /// Retorna a referência para a coleção de certificados do usuário atual.
  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _db.collection('users').doc(uid).collection('certificados');
  }

  /// Lista todos os certificados do usuário (apenas metadados).
  Future<List<Certificado>> listarTodos(String uid) async {
    final querySnapshot = await _collection(uid).get();
    return querySnapshot.docs.map((doc) {
      return Certificado.fromMap(doc.data(), doc.id);
    }).toList();
  }

  /// Salva ou atualiza um certificado.
  Future<void> salvar(String uid, Certificado certificado) async {
    await _collection(uid).doc(certificado.id).set(certificado.toMap());
  }

  /// Remove um certificado pelo ID.
  Future<void> remover(String uid, String certificadoId) async {
    await _collection(uid).doc(certificadoId).delete();
  }
}
