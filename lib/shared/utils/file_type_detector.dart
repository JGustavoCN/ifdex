import 'dart:typed_data';

enum DocumentType { pdf, png, jpeg, unknown }

class FileTypeDetector {
  /// Analisa os "Magic Bytes" de um array de bytes para determinar
  /// com precisão o tipo de arquivo real, ignorando a extensão.
  static DocumentType detect(Uint8List bytes) {
    if (bytes.length < 4) return DocumentType.unknown;

    // PDF: %PDF (25 50 44 46)
    if (bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return DocumentType.pdf;
    }

    // PNG: \x89PNG (89 50 4E 47)
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return DocumentType.png;
    }

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return DocumentType.jpeg;
    }

    return DocumentType.unknown;
  }
}
