import 'package:flutter/material.dart';

import '../../domain/models/record_field_value.dart';
import 'soft_surface_card.dart';

class RecordFieldEditor extends StatefulWidget {
  const RecordFieldEditor({
    required this.label,
    required this.initialValue,
    super.key,
  });

  final String label;
  final RecordFieldValue initialValue;

  @override
  State<RecordFieldEditor> createState() => RecordFieldEditorState();
}

class RecordFieldEditorState extends State<RecordFieldEditor> {
  late final TextEditingController _tagsController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tagsController = TextEditingController(
      text: widget.initialValue.tags.join(', '),
    );
    _textController = TextEditingController(text: widget.initialValue.text);
  }

  RecordFieldValue buildValue() {
    final tags = _tagsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return RecordFieldValue(tags: tags, text: _textController.text.trim());
  }

  @override
  void dispose() {
    _tagsController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFCAF9DC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF245437),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'タグ選択と自由記述の両方を保持できます。',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF60706F),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'タグ選択値',
              hintText: 'タグ管理方式は未定のため、MVPではカンマ区切り入力',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFFFFCFB),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _textController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: '自由記述',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFFFFCFB),
            ),
          ),
        ],
      ),
    );
  }
}
