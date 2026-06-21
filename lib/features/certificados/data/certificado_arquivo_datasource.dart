import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'certificado_arquivo_datasource.g.dart';

@riverpod
CertificadoArquivoDatasource certificadoArquivoDatasource(
  CertificadoArquivoDatasourceRef ref,
) {
  return CertificadoArquivoDatasource(FirebaseFirestore.instance);
}

class FirestoreFileSizeException implements Exception {
  final String message;
  FirestoreFileSizeException(this.message);

  @override
  String toString() => message;
}

/// Datasource responsável pelo upload e download de binários no Firestore.
class CertificadoArquivoDatasource {
  final FirebaseFirestore _db;
  static const int _maxSizeInBytes = 700 * 1024; // 700KB

  CertificadoArquivoDatasource(this._db);

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _db.collection('users').doc(uid).collection('certificados_arquivos');
  }

  /// Faz o upload de um arquivo binário.
  /// Se for imagem, tenta comprimir antes de salvar.
  /// Lança [FirestoreFileSizeException] se exceder 700KB após compressão.
  Future<void> uploadArquivo(
    String uid,
    String certificadoId,
    Uint8List bytes,
    String fileName,
  ) async {
    Uint8List dataToSave = bytes;

    // Tentar comprimir se for JPG/PNG
    final isImage =
        fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png');

    if (isImage) {
      final format = fileName.toLowerCase().endsWith('.png')
          ? CompressFormat.png
          : CompressFormat.jpeg;

      final compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1920,
        minHeight: 1080,
        quality: 70,
        format: format,
      );

      dataToSave = compressed;
    }

    if (dataToSave.lengthInBytes > _maxSizeInBytes) {
      throw FirestoreFileSizeException(
        'O arquivo excede o limite de 700KB mesmo após compressão. '
        'Por favor, utilize a opção "Link Externo".',
      );
    }

    String contentType = 'application/pdf';
    if (fileName.toLowerCase().endsWith('.png')) {
      contentType = 'image/png';
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg')) {
      contentType = 'image/jpeg';
    }

    await _collection(uid).doc(certificadoId).set({
      'id': certificadoId,
      'dados': Blob(dataToSave),
      'nomeArquivo': fileName,
      'contentType': contentType,
      'tamanhoOriginal': bytes.lengthInBytes,
      'tamanhoComprimido': dataToSave.lengthInBytes,
    });
  }

  /// Faz o download do arquivo binário sob demanda.
  Future<Uint8List?> downloadArquivo(String uid, String certificadoId) async {
    final doc = await _collection(uid).doc(certificadoId).get();
    if (doc.exists && doc.data() != null) {
      final blob = doc.data()!['dados'] as Blob?;
      return blob?.bytes;
    }
    return null;
  }

  /// Remove o arquivo do Firestore.
  Future<void> removerArquivo(String uid, String certificadoId) async {
    await _collection(uid).doc(certificadoId).delete();
  }
}
