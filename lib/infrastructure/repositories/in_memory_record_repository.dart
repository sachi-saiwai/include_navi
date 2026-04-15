import '../../domain/models/record_entry.dart';
import '../../domain/repositories/record_repository.dart';

class InMemoryRecordRepository implements RecordRepository {
  final Map<String, RecordEntry> _store = <String, RecordEntry>{};

  @override
  Future<List<RecordEntry>> fetchByChildId(String childId) async {
    final items = _store.values.where((record) => record.childId == childId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  @override
  Future<RecordEntry?> findById(String id) async => _store[id];

  @override
  Future<RecordEntry> save(RecordEntry record) async {
    _store[record.id] = record;
    return record;
  }
}
