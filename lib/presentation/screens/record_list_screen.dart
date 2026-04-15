import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/mood_stamp.dart';
import '../../domain/models/record_entry.dart';
import 'record_detail_screen.dart';
import 'record_form_screen.dart';
import 'reflection_screen.dart';
import 'sharing_screen.dart';
import '../widgets/app_shell.dart';
import '../widgets/message_banner.dart';

class RecordListScreen extends StatelessWidget {
  const RecordListScreen({super.key});

  static const routeName = '/records';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final child = controller.selectedChild;

    return AppShell(
      title: child == null ? '記録一覧' : '${child.nickname}の記録一覧',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: child == null
            ? null
            : () {
                Navigator.of(context).pushNamed(RecordFormScreen.routeName);
              },
        icon: const Icon(Icons.add),
        label: const Text('記録追加'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const MessageBanner(),
          if (child == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('子どもが未選択です。子ども一覧から選択してください。'),
              ),
            )
          else ...<Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'プロフィール',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('ニックネーム: ${child.nickname}'),
                    const SizedBox(height: 8),
                    Text(
                      child.traitsMemo.isEmpty ? '特性メモ未入力' : child.traitsMemo,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ReflectionScreen.routeName);
                  },
                  icon: const Icon(Icons.insights),
                  label: const Text('振り返り画面へ'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final months = controller.getAvailableRecordMonths();
                    await controller.exportPdf(
                      month: months.isEmpty ? DateTime.now() : months.first,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('月次PDF出力'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SharingScreen.routeName);
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text('招待/共有'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.latestPdfExport != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('直近のPDF生成結果'),
                  subtitle: Text(
                    '生成日時: ${_dateTime(controller.latestPdfExport!.createdAt)} / ${controller.latestPdfExport!.fileBytes.length} bytes\n月次サマリーPDFを生成しました。TODO: 保存先・共有方法は未定のため未実装',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (controller.selectedChildRecords.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('記録はまだありません。'),
                ),
              )
            else
              ...controller.selectedChildRecords.map(
                (record) => _RecordListTile(record: record),
              ),
          ],
        ],
      ),
    );
  }
}

class _RecordListTile extends StatelessWidget {
  const _RecordListTile({required this.record});

  final RecordEntry record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_date(record.date)),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9FBF4),
          child: Text(_moodEmoji(record)),
        ),
        subtitle: Text(
          record.trouble.text.isEmpty
              ? '今日あったこと未入力'
              : '今日あったこと: ${record.trouble.text}',
        ),
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(RecordDetailScreen.routeName, arguments: record.id);
        },
      ),
    );
  }
}

String _moodEmoji(RecordEntry record) {
  final mood = MoodStamp.fromStorageValue(record.condition.tags.firstOrNull);
  return mood?.emoji ?? '•';
}

String _date(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String _dateTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${_date(value)} $hour:$minute';
}
