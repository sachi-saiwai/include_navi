import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
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
                                '記録項目は入力項目とABC表示文言を分けて表示しています。未定事項は未定のまま保持しています。',
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
                          label: '今日のコンディション',
                          value: record.condition,
                        ),
                        const SizedBox(height: 16),
                        RecordFieldView(label: '困りごと', value: record.trouble),
                        const SizedBox(height: 16),
                        RecordFieldView(label: 'きっかけ', value: record.trigger),
                        const SizedBox(height: 16),
                        RecordFieldView(label: 'そのあと', value: record.after),
                        const SizedBox(height: 16),
                        _AbcLanguageSection(record: record),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _AbcLanguageSection extends StatelessWidget {
  const _AbcLanguageSection({required this.record});

  final RecordEntry record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ABC表示文言',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'TODO: 「困りごと」「そのあと」と「起きたこと」「本人の変化」の対応関係は未定です。ここでは入力項目と表示文言を分離して表示しています。',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF677574),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 18),
          _AbcRow(label: 'きっかけ', value: _summary(record.trigger.text)),
          const SizedBox(height: 12),
          const _AbcRow(label: '起きたこと', value: 'Not implemented'),
          const SizedBox(height: 12),
          const _AbcRow(label: '本人の変化', value: 'Not implemented'),
        ],
      ),
    );
  }
}

class _AbcRow extends StatelessWidget {
  const _AbcRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF006A6B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.7),
          ),
        ],
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
