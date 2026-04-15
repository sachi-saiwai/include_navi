import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../widgets/app_shell.dart';
import '../widgets/soft_surface_card.dart';

class ChildFormScreen extends StatefulWidget {
  const ChildFormScreen({super.key});

  static const routeName = '/child-form';

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> {
  final _nicknameController = TextEditingController();
  final _traitsMemoController = TextEditingController();
  String? _editingChildId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;

    final childId = ModalRoute.of(context)?.settings.arguments as String?;
    if (childId == null) {
      return;
    }

    final controller = AppScope.of(context);
    final matches = controller.childProfiles.where(
      (item) => item.id == childId,
    );
    final child = matches.isEmpty ? null : matches.first;
    if (child == null) {
      return;
    }

    _editingChildId = child.id;
    _nicknameController.text = child.nickname;
    _traitsMemoController.text = child.traitsMemo;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _traitsMemoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final theme = Theme.of(context);

    return AppShell(
      title: _editingChildId == null ? '子ども作成' : '子ども編集',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
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
                            _editingChildId == null ? '新しいプロフィール' : 'プロフィール編集',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF245437),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _editingChildId == null
                              ? '子どもの基本情報を登録します。'
                              : '登録済みプロフィールの内容を更新します。',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'MVPではニックネームと特性メモのみを保持します。生年月日などの他項目は未定のため実装していません。',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF657372),
                            height: 1.7,
                          ),
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
                          '入力フォーム',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            labelText: 'ニックネーム',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFFFFCFB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _traitsMemoController,
                          minLines: 5,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            labelText: '特性メモ',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFFFFCFB),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: () async {
                              await controller.saveChildProfile(
                                id: _editingChildId,
                                nickname: _nicknameController.text.trim(),
                                traitsMemo: _traitsMemoController.text.trim(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
