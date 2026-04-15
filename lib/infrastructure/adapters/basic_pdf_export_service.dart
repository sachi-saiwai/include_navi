import 'dart:convert';
import 'dart:typed_data';

import '../../domain/models/app_user.dart';
import '../../domain/models/child_profile.dart';
import '../../domain/models/pdf_export.dart';
import '../../domain/models/record_entry.dart';
import '../../domain/services/pdf_export_service.dart';

class BasicPdfExportService implements PdfExportService {
  @override
  Future<PdfExport> exportChildRecords({
    required AppUser createdBy,
    required ChildProfile child,
    required List<RecordEntry> records,
  }) async {
    final createdAt = DateTime.now();
    final buffer = StringBuffer()
      ..writeln('%PDF-1.4')
      ..writeln('% Minimal PDF placeholder generated inside MVP scaffold')
      ..writeln(
        '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj',
      )
      ..writeln(
        '2 0 obj << /Type /Pages /Count 1 /Kids [3 0 R] >> endobj',
      )
      ..writeln(
        '3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R >> endobj',
      );

    final content = _buildTextContent(child: child, createdBy: createdBy, records: records);
    final stream = 'BT /F1 12 Tf 40 780 Td (${_escape(content)}) Tj ET';
    buffer
      ..writeln(
        '4 0 obj << /Length ${stream.length} >> stream',
      )
      ..writeln(stream)
      ..writeln('endstream endobj')
      ..writeln('xref')
      ..writeln('0 5')
      ..writeln('0000000000 65535 f ')
      ..writeln('0000000010 00000 n ')
      ..writeln('0000000060 00000 n ')
      ..writeln('0000000120 00000 n ')
      ..writeln('0000000220 00000 n ')
      ..writeln('trailer << /Root 1 0 R /Size 5 >>')
      ..writeln('startxref')
      ..writeln('320')
      ..writeln('%%EOF');

    return PdfExport(
      id: 'pdf-${createdAt.microsecondsSinceEpoch}',
      childId: child.id,
      createdByUserId: createdBy.id,
      createdAt: createdAt,
      fileBytes: Uint8List.fromList(utf8.encode(buffer.toString())),
      fileUrl: null,
    );
  }

  String _buildTextContent({
    required ChildProfile child,
    required AppUser createdBy,
    required List<RecordEntry> records,
  }) {
    final lines = <String>[
      'Include Navi',
      'Child: ${child.nickname}',
      'Created by: ${createdBy.displayName ?? createdBy.id}',
      'Record count: ${records.length}',
      'TODO: Output range/unit is undecided.',
    ];

    for (final record in records.take(3)) {
      lines.add(
        '${record.date.toIso8601String().split("T").first} / ${record.condition.text}',
      );
    }

    return lines.join(' | ');
  }

  String _escape(String value) {
    return value
        .replaceAll('\\', r'\\')
        .replaceAll('(', r'\(')
        .replaceAll(')', r'\)');
  }
}
