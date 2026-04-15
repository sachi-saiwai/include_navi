import 'package:flutter/material.dart';

import '../../domain/models/record_field_value.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            if (caption != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                caption!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: value.tags.isEmpty
                  ? const <Widget>[Chip(label: Text('タグ未入力'))]
                  : value.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 12),
            SelectableText(
              value.text.isEmpty ? '自由記述未入力' : value.text,
            ),
          ],
        ),
      ),
    );
  }
}
