import 'dart:typed_data';

class PdfExport {
  const PdfExport({
    required this.id,
    required this.childId,
    required this.createdByUserId,
    required this.createdAt,
    required this.fileBytes,
    this.fileUrl,
  });

  final String id;
  final String childId;
  final String createdByUserId;
  final String? fileUrl;
  final DateTime createdAt;
  final Uint8List fileBytes;
}
