import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/record_entry.dart';
import '../widgets/record_field_view.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key});

  static const routeName = '/record-detail';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final recordId = ModalRoute.of(context)?.settings.arguments as String?;
    final record = recordId == null ? null : controller.findRecordById(recordId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('記録詳細'),
      ),
      body: SafeArea(
        child: record == null
            ? const Center(child: Text('記録が見つかりません。'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '基本情報',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text('日付: ${_formatDate(record.date)}'),
                          const SizedBox(height: 8),
                          const Text('FIXME: 記録の編集可否・削除可否は未定のため、このMVPでは詳細表示のみ実装しています。'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecordFieldView(label: '今日のコンディション', value: record.condition),
                  RecordFieldView(label: '困りごと', value: record.trouble),
                  RecordFieldView(label: 'きっかけ', value: record.trigger),
                  RecordFieldView(label: 'そのあと', value: record.after),
                  const SizedBox(height: 16),
                  _AbcLanguageSection(record: record),
                ],
              ),
      ),
    );
  }
}

class _AbcLanguageSection extends StatelessWidget {
  const _AbcLanguageSection({required this.record});

  final RecordEntry record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ABC表示文言', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'TODO: 「困りごと」「そのあと」と「起きたこと」「本人の変化」の対応関係は未定です。ここでは入力項目と表示文言を分離して表示しています。',
            ),
            const SizedBox(height: 16),
            Text('きっかけ: ${_summary(record.trigger.text)}'),
            const SizedBox(height: 8),
            Text('起きたこと: Not implemented'),
            const SizedBox(height: 8),
            Text('本人の変化: Not implemented'),
          ],
        ),
      ),
    );
  }
}

String _summary(String value) => value.isEmpty ? '未入力' : value;

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
