import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/mood_stamp.dart';
import '../../domain/models/record_entry.dart';
import '../widgets/record_field_view.dart';
import '../widgets/app_shell.dart';
import '../widgets/soft_surface_card.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key});

  static const routeName = '/record-detail';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final recordId = ModalRoute.of(context)?.settings.arguments as String?;
    final record = recordId == null
        ? null
        : controller.findRecordById(recordId);
    final theme = Theme.of(context);

    return AppShell(
      title: '記録詳細',
      body: record == null
          ? const Center(child: Text('記録が見つかりません。'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SoftSurfaceCard(
                          padding: const EdgeInsets.all(24),
                          backgroundColor: const Color(0xFFFFFDFC),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCAF9DC),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '記録の見返し',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: const Color(0xFF245437),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _formatDate(record.date),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '記嫌スタンプと、その日にあったことの流れを見返せます。',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF667473),
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SoftSurfaceCard(
                          padding: const EdgeInsets.all(24),
                          backgroundColor: const Color(0xFFF8FFFB),
                          borderColor: const Color(0xFFDDEEE6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '基本情報',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('日付: ${_formatDate(record.date)}'),
                              const SizedBox(height: 8),
                              const Text(
                                'FIXME: 記録の編集可否・削除可否は未定のため、このMVPでは詳細表示のみ実装しています。',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        RecordFieldView(
                          label: '機嫌スタンプ',
                          value: record.condition,
                          caption: _moodCaption(record),
                        ),
                        const SizedBox(height: 16),
                        RecordFieldView(
                          label: '今日あったこと',
                          value: record.trouble,
                          showTags: false,
                        ),
                        const SizedBox(height: 16),
                        RecordFieldView(
                          label: 'きっかけ',
                          value: record.trigger,
                          showTags: false,
                        ),
                        const SizedBox(height: 16),
                        RecordFieldView(
                          label: 'その後',
                          value: record.after,
                          showTags: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

String? _moodCaption(RecordEntry record) {
  final mood = MoodStamp.fromStorageValue(record.condition.tags.firstOrNull);
  if (mood == null) {
    return '機嫌スタンプ未選択';
  }
  return '${mood.emoji} ${mood.label}';
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
