import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/record_field_value.dart';
import '../widgets/record_field_editor.dart';

class RecordFormScreen extends StatefulWidget {
  const RecordFormScreen({super.key});

  static const routeName = '/record-form';

  @override
  State<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends State<RecordFormScreen> {
  final _dateController = TextEditingController();
  final _conditionKey = GlobalKey<RecordFieldEditorState>();
  final _troubleKey = GlobalKey<RecordFieldEditorState>();
  final _triggerKey = GlobalKey<RecordFieldEditorState>();
  final _afterKey = GlobalKey<RecordFieldEditorState>();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController.text = _formatDate(now);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('記録入力'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '入力上の注記',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('TODO: 必須/任意は未定のため、このMVPでは必須バリデーションを設けていません。'),
                    const SizedBox(height: 4),
                    const Text('TODO: 1日に複数記録できるか未定のため、重複制御は実装していません。'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: '日付',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final initialDate = _parseDate(_dateController.text) ?? DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  _dateController.text = _formatDate(picked);
                }
              },
            ),
            const SizedBox(height: 16),
            RecordFieldEditor(
              key: _conditionKey,
              label: '今日のコンディション',
              initialValue: const RecordFieldValue(),
            ),
            RecordFieldEditor(
              key: _troubleKey,
              label: '困りごと',
              initialValue: const RecordFieldValue(),
            ),
            RecordFieldEditor(
              key: _triggerKey,
              label: 'きっかけ',
              initialValue: const RecordFieldValue(),
            ),
            RecordFieldEditor(
              key: _afterKey,
              label: 'そのあと',
              initialValue: const RecordFieldValue(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final date = _parseDate(_dateController.text) ?? DateTime.now();
                await controller.saveRecord(
                  date: date,
                  condition: _conditionKey.currentState?.buildValue() ?? const RecordFieldValue(),
                  trouble: _troubleKey.currentState?.buildValue() ?? const RecordFieldValue(),
                  trigger: _triggerKey.currentState?.buildValue() ?? const RecordFieldValue(),
                  after: _afterKey.currentState?.buildValue() ?? const RecordFieldValue(),
                );
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pop();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime? _parseDate(String value) {
  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
