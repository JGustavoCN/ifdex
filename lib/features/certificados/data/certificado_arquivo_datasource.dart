import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'certificado_arquivo_datasource.g.dart';

@riverpod
CertificadoArquivoDatasource certificadoArquivoDatasource(
  CertificadoArquivoDatasourceRef ref,
) {
  return CertificadoArquivoDatasource();
}

class StorageFileSizeException implements Exception {
  final String message;
  StorageFileSizeException(this.message);

  @override
  String toString() => message;
}

/// Datasource responsável pelo upload e download de binários no Supabase Storage.
class CertificadoArquivoDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _bucket = 'certificados_arquivos';
  static const int _maxSizeInBytes = 10 * 1024 * 1024; // 10MB

  /// Faz o upload de um arquivo binário para o Supabase.
  /// Lança [StorageFileSizeException] se exceder 10MB.
  Future<void> uploadArquivo(
    String uid,
    String certificadoId,
    Uint8List bytes,
    String
    fileName, // Mantido por compatibilidade com a assinatura, mas path é pdf/jpg
  ) async {
    if (bytes.lengthInBytes > _maxSizeInBytes) {
      throw StorageFileSizeException(
        'O arquivo excede o limite de 10MB. '
        'Por favor, utilize a opção "Link Externo".',
      );
    }

    // Identifica o formato a partir da extensão ou usa .pdf como padrão de backup
    String ext = '.pdf';
    if (fileName.toLowerCase().endsWith('.png')) {
      ext = '.png';
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg')) {
      ext = '.jpg';
    }

    final caminho = '$uid/$certificadoId$ext';

    // Configura o ContentType com base na extensão
    String contentType = 'application/pdf';
    if (ext == '.png') contentType = 'image/png';
    if (ext == '.jpg') contentType = 'image/jpeg';

    await _supabase.storage
        .from(_bucket)
        .uploadBinary(
          caminho,
          bytes,
          fileOptions: FileOptions(upsert: true, contentType: contentType),
        );
  }

  /// Faz o download do arquivo binário sob demanda do Supabase.
  Future<Uint8List?> downloadArquivo(
    String uid,
    String certificadoId, {
    String ext = '.pdf',
  }) async {
    try {
      final caminho = '$uid/$certificadoId$ext';
      return await _supabase.storage.from(_bucket).download(caminho);
    } catch (e) {
      return null;
    }
  }

  /// Remove o arquivo do Supabase Storage.
  Future<void> removerArquivo(
    String uid,
    String certificadoId, {
    String ext = '.pdf',
  }) async {
    try {
      final caminho = '$uid/$certificadoId$ext';
      await _supabase.storage.from(_bucket).remove([caminho]);
    } catch (e) {
      // Ignora erro se o arquivo não existir
    }
  }
}
