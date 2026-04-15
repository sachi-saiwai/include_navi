import '../models/record_entry.dart';

abstract class RecordRepository {
  Future<List<RecordEntry>> fetchByChildId(String childId);

  Future<RecordEntry?> findById(String id);

  Future<RecordEntry> save(RecordEntry record);
}
