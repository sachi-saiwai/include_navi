class MoodStamp {
  const MoodStamp({
    required this.storageValue,
    required this.emoji,
    required this.label,
    required this.score,
  });

  final String storageValue;
  final String emoji;
  final String label;
  final int score;

  static const List<MoodStamp> options = <MoodStamp>[
    MoodStamp(storageValue: '😄 ごきげん', emoji: '😄', label: 'ごきげん', score: 5),
    MoodStamp(storageValue: '🙂 おだやか', emoji: '🙂', label: 'おだやか', score: 4),
    MoodStamp(storageValue: '😐 ふつう', emoji: '😐', label: 'ふつう', score: 3),
    MoodStamp(storageValue: '😢 しんどい', emoji: '😢', label: 'しんどい', score: 2),
    MoodStamp(storageValue: '😡 いらいら', emoji: '😡', label: 'いらいら', score: 1),
  ];

  static MoodStamp? fromStorageValue(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    for (final option in options) {
      if (option.storageValue == value) {
        return option;
      }
    }
    return null;
  }
}
