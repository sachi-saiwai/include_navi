import '../models/app_user.dart';
import '../models/child_profile.dart';
import '../models/pdf_export.dart';
import '../models/record_entry.dart';

abstract class PdfExportService {
  Future<PdfExport> exportChildRecords({
    required AppUser createdBy,
    required ChildProfile child,
    required List<RecordEntry> records,
    DateTime? month,
  });
}
