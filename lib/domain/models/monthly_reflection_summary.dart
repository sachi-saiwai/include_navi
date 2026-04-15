import 'mood_stamp.dart';

class MonthlyReflectionSummary {
  const MonthlyReflectionSummary({
    required this.month,
    required this.totalRecords,
    required this.recordedDays,
    required this.recordsWithTrigger,
    required this.recordsWithAfter,
    required this.moodCounts,
    required this.timeline,
    required this.highlights,
  });

  final DateTime month;
  final int totalRecords;
  final int recordedDays;
  final int recordsWithTrigger;
  final int recordsWithAfter;
  final List<MonthlyMoodCount> moodCounts;
  final List<MonthlyRecordPoint> timeline;
  final List<String> highlights;
}

class MonthlyMoodCount {
  const MonthlyMoodCount({required this.stamp, required this.count});

  final MoodStamp stamp;
  final int count;
}

class MonthlyRecordPoint {
  const MonthlyRecordPoint({
    required this.date,
    required this.moodStamp,
    required this.happenedText,
    required this.triggerText,
    required this.afterText,
  });

  final DateTime date;
  final MoodStamp? moodStamp;
  final String happenedText;
  final String triggerText;
  final String afterText;
}
