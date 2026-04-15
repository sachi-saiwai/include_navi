import 'record_field_value.dart';

class RecordEntry {
  const RecordEntry({
    required this.id,
    required this.childId,
    required this.date,
    required this.condition,
    required this.trouble,
    required this.trigger,
    required this.after,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String childId;
  final DateTime date;
  final RecordFieldValue condition;
  final RecordFieldValue trouble;
  final RecordFieldValue trigger;
  final RecordFieldValue after;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecordEntry copyWith({
    String? id,
    String? childId,
    DateTime? date,
    RecordFieldValue? condition,
    RecordFieldValue? trouble,
    RecordFieldValue? trigger,
    RecordFieldValue? after,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecordEntry(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      date: date ?? this.date,
      condition: condition ?? this.condition,
      trouble: trouble ?? this.trouble,
      trigger: trigger ?? this.trigger,
      after: after ?? this.after,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
