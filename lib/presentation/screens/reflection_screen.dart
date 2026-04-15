import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/monthly_reflection_summary.dart';
import '../widgets/app_shell.dart';
import '../widgets/soft_surface_card.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  static const routeName = '/reflection';

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  DateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final months = controller.getAvailableRecordMonths();
    final fallbackMonth = months.isEmpty ? DateTime.now() : months.first;
    final selectedMonth = _resolveSelectedMonth(months, fallbackMonth);
    final summary = controller.buildMonthlySummary(selectedMonth);

    return AppShell(
      title: '振り返り',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SoftSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '月ごとの変化を見返す',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text('対象の子ども: ${controller.selectedChild?.nickname ?? '未選択'}'),
                const SizedBox(height: 16),
                DropdownButtonFormField<DateTime>(
                  initialValue: selectedMonth,
                  decoration: const InputDecoration(
                    labelText: '対象月',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFFCFB),
                  ),
                  items: months.isEmpty
                      ? <DropdownMenuItem<DateTime>>[
                          DropdownMenuItem<DateTime>(
                            value: fallbackMonth,
                            child: Text(_formatMonth(fallbackMonth)),
                          ),
                        ]
                      : months.map((month) {
                          return DropdownMenuItem<DateTime>(
                            value: month,
                            child: Text(_formatMonth(month)),
                          );
                        }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedMonth = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    await controller.exportPdf(month: selectedMonth);
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('この月のPDFを作る'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MonthlySummaryCards(summary: summary),
          const SizedBox(height: 16),
          _MoodBarChart(summary: summary),
          const SizedBox(height: 16),
          _MonthlyTimeline(summary: summary),
          if (controller.latestPdfExport != null) ...<Widget>[
            const SizedBox(height: 16),
            SoftSurfaceCard(
              child: Text(
                '直近のPDF生成: ${_formatDateTime(controller.latestPdfExport!.createdAt)} / ${controller.latestPdfExport!.fileBytes.length} bytes',
              ),
            ),
          ],
          const SizedBox(height: 16),
          SoftSurfaceCard(
            child: const Text('TODO: サマリー文面の表現ルールやPDFの配布方法は今後の詳細仕様に合わせて調整します。'),
          ),
        ],
      ),
    );
  }

  DateTime _resolveSelectedMonth(
    List<DateTime> months,
    DateTime fallbackMonth,
  ) {
    if (_selectedMonth == null) {
      _selectedMonth = fallbackMonth;
      return _selectedMonth!;
    }

    for (final month in months) {
      if (month.year == _selectedMonth!.year &&
          month.month == _selectedMonth!.month) {
        _selectedMonth = month;
        return month;
      }
    }

    _selectedMonth = fallbackMonth;
    return _selectedMonth!;
  }
}

class _MonthlySummaryCards extends StatelessWidget {
  const _MonthlySummaryCards({required this.summary});

  final MonthlyReflectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = <_SummaryItem>[
      _SummaryItem(label: '記録件数', value: '${summary.totalRecords}件'),
      _SummaryItem(label: '記録した日', value: '${summary.recordedDays}日'),
      _SummaryItem(label: 'きっかけ入力', value: '${summary.recordsWithTrigger}件'),
      _SummaryItem(label: 'その後入力', value: '${summary.recordsWithAfter}件'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        if (!isWide) {
          return Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SummaryCard(item: item),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: <Widget>[
            for (var index = 0; index < items.length; index++) ...<Widget>[
              Expanded(child: _SummaryCard(item: items[index])),
              if (index < items.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }
}

class _SummaryItem {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.item});

  final _SummaryItem item;

  @override
  Widget build(BuildContext context) {
    return SoftSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF667473)),
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _MoodBarChart extends StatelessWidget {
  const _MoodBarChart({required this.summary});

  final MonthlyReflectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final maxCount = summary.moodCounts.fold<int>(
      1,
      (previousValue, item) =>
          item.count > previousValue ? item.count : previousValue,
    );

    return SoftSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '機嫌スタンプの月次グラフ',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          if (summary.totalRecords == 0)
            const Text('この月の記録はまだありません。')
          else
            ...summary.moodCounts.map((item) {
              final widthFactor = item.count == 0 ? 0.0 : item.count / maxCount;
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 96,
                      child: Text('${item.stamp.emoji} ${item.stamp.label}'),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: widthFactor,
                          minHeight: 14,
                          backgroundColor: const Color(0xFFF1EEEB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF006A6B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${item.count}'),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _MonthlyTimeline extends StatelessWidget {
  const _MonthlyTimeline({required this.summary});

  final MonthlyReflectionSummary summary;

  @override
  Widget build(BuildContext context) {
    return SoftSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '月の記録サマリー',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          if (summary.highlights.isNotEmpty) ...<Widget>[
            Text(
              'よく見返したい出来事',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...summary.highlights.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('・$text'),
              ),
            ),
            const SizedBox(height: 18),
          ],
          if (summary.timeline.isEmpty)
            const Text('この月の記録はまだありません。')
          else
            ...summary.timeline.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCFB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF0ECE8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${item.moodStamp?.emoji ?? '•'} ${_formatDay(item.date)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('今日あったこと: ${_fallback(item.happenedText)}'),
                    const SizedBox(height: 4),
                    Text('きっかけ: ${_fallback(item.triggerText)}'),
                    const SizedBox(height: 4),
                    Text('その後: ${_fallback(item.afterText)}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _formatMonth(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  return '${value.year}年$month月';
}

String _formatDay(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$month/$day';
}

String _fallback(String value) => value.isEmpty ? '未入力' : value;

String _formatDateTime(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.year}-$month-$day $hour:$minute';
}
