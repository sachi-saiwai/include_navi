import 'package:flutter/material.dart';

import '../../domain/models/record_field_value.dart';
import 'soft_surface_card.dart';

class RecordFieldEditor extends StatefulWidget {
  const RecordFieldEditor({
    required this.label,
    required this.initialValue,
    this.description,
    this.tagLabel = 'タグ選択値',
    this.textLabel = '自由記述',
    this.tagHintText,
    this.textHintText,
    this.presetTags = const <String>[],
    this.showTagInput = true,
    this.singleSelectPreset = false,
    super.key,
  });

  final String label;
  final RecordFieldValue initialValue;
  final String? description;
  final String tagLabel;
  final String textLabel;
  final String? tagHintText;
  final String? textHintText;
  final List<String> presetTags;
  final bool showTagInput;
  final bool singleSelectPreset;

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

  void _togglePresetTag(String tag) {
    final currentTags = _tagsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    if (widget.singleSelectPreset) {
      if (currentTags.length == 1 && currentTags.first == tag) {
        _tagsController.text = '';
      } else {
        _tagsController.text = tag;
      }
      setState(() {});
      return;
    }

    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else {
      currentTags.add(tag);
    }
    _tagsController.text = currentTags.join(', ');
    setState(() {});
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
            widget.description ?? 'タグ選択と自由記述の両方を保持できます。',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF60706F),
              height: 1.5,
            ),
          ),
          if (widget.presetTags.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.presetTags.map((tag) {
                final isSelected = buildValue().tags.contains(tag);
                return FilterChip(
                  selected: isSelected,
                  label: Text(tag),
                  onSelected: (_) => _togglePresetTag(tag),
                );
              }).toList(),
            ),
          ],
          if (widget.showTagInput) ...<Widget>[
            const SizedBox(height: 14),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: widget.tagLabel,
                hintText: widget.tagHintText ?? 'カンマ区切りで入力',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFFFFFCFB),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: 14),
          TextField(
            controller: _textController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: widget.textLabel,
              hintText: widget.textHintText,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0xFFFFFCFB),
            ),
          ),
        ],
      ),
    );
  }
}
