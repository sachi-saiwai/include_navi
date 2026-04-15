import '../domain/models/monthly_reflection_summary.dart';
import '../domain/models/mood_stamp.dart';
import '../domain/models/record_entry.dart';

MonthlyReflectionSummary buildMonthlyReflectionSummary({
  required DateTime month,
  required List<RecordEntry> records,
}) {
  final normalizedMonth = DateTime(month.year, month.month);
  final filtered = records.where((record) {
    return record.date.year == normalizedMonth.year &&
        record.date.month == normalizedMonth.month;
  }).toList()..sort((left, right) => left.date.compareTo(right.date));

  final recordedDays = <String>{};
  var recordsWithTrigger = 0;
  var recordsWithAfter = 0;

  for (final record in filtered) {
    recordedDays.add(_dateKey(record.date));
    if (record.trigger.text.trim().isNotEmpty) {
      recordsWithTrigger += 1;
    }
    if (record.after.text.trim().isNotEmpty) {
      recordsWithAfter += 1;
    }
  }

  final moodCounts = MoodStamp.options.map((stamp) {
    final count = filtered.where((record) {
      final selected = MoodStamp.fromStorageValue(
        record.condition.tags.firstOrNull,
      );
      return selected?.storageValue == stamp.storageValue;
    }).length;
    return MonthlyMoodCount(stamp: stamp, count: count);
  }).toList();

  final timeline = filtered.map((record) {
    return MonthlyRecordPoint(
      date: record.date,
      moodStamp: MoodStamp.fromStorageValue(record.condition.tags.firstOrNull),
      happenedText: record.trouble.text.trim(),
      triggerText: record.trigger.text.trim(),
      afterText: record.after.text.trim(),
    );
  }).toList();

  final highlights = filtered
      .map((record) => record.trouble.text.trim())
      .where((text) => text.isNotEmpty)
      .take(3)
      .toList();

  return MonthlyReflectionSummary(
    month: normalizedMonth,
    totalRecords: filtered.length,
    recordedDays: recordedDays.length,
    recordsWithTrigger: recordsWithTrigger,
    recordsWithAfter: recordsWithAfter,
    moodCounts: moodCounts,
    timeline: timeline,
    highlights: highlights,
  );
}

String _dateKey(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
