import 'package:flutter/material.dart';

import '../../domain/models/record_field_value.dart';
import 'soft_surface_card.dart';

class RecordFieldView extends StatelessWidget {
  const RecordFieldView({
    required this.label,
    required this.value,
    this.caption,
    super.key,
  });

  final String label;
  final RecordFieldValue value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              caption!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B7A79),
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: value.tags.isEmpty
                ? const <Widget>[Chip(label: Text('タグ未入力'))]
                : value.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCFB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0ECE8)),
            ),
            child: SelectableText(
              value.text.isEmpty ? '自由記述未入力' : value.text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}
