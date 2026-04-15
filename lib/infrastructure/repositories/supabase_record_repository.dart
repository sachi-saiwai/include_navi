import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/record_entry.dart';
import '../../domain/models/record_field_value.dart';
import '../../domain/repositories/record_repository.dart';

class SupabaseRecordRepository implements RecordRepository {
  SupabaseRecordRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'records';

  @override
  Future<List<RecordEntry>> fetchByChildId(String childId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('child_id', childId)
        .order('date', ascending: false)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_mapRecord)
        .toList();
  }

  @override
  Future<RecordEntry?> findById(String id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return _mapRecord(response);
  }

  @override
  Future<RecordEntry> save(RecordEntry record) async {
    final response = await _client
        .from(_table)
        .upsert(<String, dynamic>{
          'id': record.id,
          'child_id': record.childId,
          'date': record.date.toIso8601String(),
          'condition_text': record.condition.text,
          'trouble_text': record.trouble.text,
          'trigger_text': record.trigger.text,
          'after_text': record.after.text,
          'condition_tags': record.condition.tags,
          'trouble_tags': record.trouble.tags,
          'trigger_tags': record.trigger.tags,
          'after_tags': record.after.tags,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
        }, onConflict: 'id')
        .select()
        .single();

    return _mapRecord(response);
  }

  RecordEntry _mapRecord(Map<String, dynamic> data) {
    return RecordEntry(
      id: data['id'] as String,
      childId: data['child_id'] as String,
      date: DateTime.parse(data['date'] as String),
      condition: RecordFieldValue(
        text: data['condition_text'] as String? ?? '',
        tags: _toStringList(data['condition_tags']),
      ),
      trouble: RecordFieldValue(
        text: data['trouble_text'] as String? ?? '',
        tags: _toStringList(data['trouble_tags']),
      ),
      trigger: RecordFieldValue(
        text: data['trigger_text'] as String? ?? '',
        tags: _toStringList(data['trigger_tags']),
      ),
      after: RecordFieldValue(
        text: data['after_text'] as String? ?? '',
        tags: _toStringList(data['after_tags']),
      ),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }

  List<String> _toStringList(dynamic value) {
    if (value is List<dynamic>) {
      return value.map((item) => item.toString()).toList();
    }
    return const <String>[];
  }
}
