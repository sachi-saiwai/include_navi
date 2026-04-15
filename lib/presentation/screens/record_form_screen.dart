import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../domain/models/record_field_value.dart';
import '../../domain/models/mood_stamp.dart';
import '../widgets/record_field_editor.dart';
import '../widgets/app_shell.dart';
import '../widgets/soft_surface_card.dart';

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
    final theme = Theme.of(context);

    return AppShell(
      title: '記録入力',
      body: ListView(
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
                            '今日のできごとを記録',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF245437),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'その日の様子を、4つの項目だけでシンプルに残せます。',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '機嫌スタンプ、今日あったこと、きっかけ、その後を記録します。保存後は月次の振り返り画面からグラフとサマリーを見返せます。',
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
                          '入力上の注記',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'TODO: 必須/任意は未定のため、このMVPでは必須バリデーションを設けていません。',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SoftSurfaceCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '基本情報',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
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
                            filled: true,
                            fillColor: Color(0xFFFFFCFB),
                          ),
                          onTap: () async {
                            final initialDate =
                                _parseDate(_dateController.text) ??
                                DateTime.now();
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecordFieldEditor(
                    key: _conditionKey,
                    label: '機嫌スタンプ',
                    initialValue: const RecordFieldValue(),
                    description: '機嫌をスタンプで選び、必要ならメモも残せます。',
                    presetTags: MoodStamp.options
                        .map((option) => option.storageValue)
                        .toList(),
                    showTagInput: false,
                    singleSelectPreset: true,
                    textLabel: 'メモ（任意）',
                    textHintText: 'その日の機嫌について補足があれば入力',
                  ),
                  const SizedBox(height: 16),
                  RecordFieldEditor(
                    key: _troubleKey,
                    label: '今日あったこと',
                    initialValue: const RecordFieldValue(),
                    description: 'その日にあった出来事を自由に記録します。',
                    showTagInput: false,
                    textLabel: '内容',
                    textHintText: '今日の出来事を書く',
                  ),
                  const SizedBox(height: 16),
                  RecordFieldEditor(
                    key: _triggerKey,
                    label: 'きっかけ',
                    initialValue: const RecordFieldValue(),
                    description: '何がきっかけだったかを残します。',
                    showTagInput: false,
                    textLabel: '内容',
                    textHintText: 'きっかけを書く',
                  ),
                  const SizedBox(height: 16),
                  RecordFieldEditor(
                    key: _afterKey,
                    label: 'その後',
                    initialValue: const RecordFieldValue(),
                    description: '出来事のあと、どうなったかを残します。',
                    showTagInput: false,
                    textLabel: '内容',
                    textHintText: 'その後の様子を書く',
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final date =
                            _parseDate(_dateController.text) ?? DateTime.now();
                        await controller.saveRecord(
                          date: date,
                          condition:
                              _conditionKey.currentState?.buildValue() ??
                              const RecordFieldValue(),
                          trouble:
                              _troubleKey.currentState?.buildValue() ??
                              const RecordFieldValue(),
                          trigger:
                              _triggerKey.currentState?.buildValue() ??
                              const RecordFieldValue(),
                          after:
                              _afterKey.currentState?.buildValue() ??
                              const RecordFieldValue(),
                        );
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('保存する'),
                    ),
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
