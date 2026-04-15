class RecordFieldValue {
  const RecordFieldValue({
    this.tags = const <String>[],
    this.text = '',
  });

  final List<String> tags;
  final String text;

  RecordFieldValue copyWith({
    List<String>? tags,
    String? text,
  }) {
    return RecordFieldValue(
      tags: tags ?? this.tags,
      text: text ?? this.text,
    );
  }
}
