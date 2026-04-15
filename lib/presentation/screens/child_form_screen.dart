import 'package:flutter/material.dart';

import '../../app/app_scope.dart';

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
    final matches = controller.childProfiles.where((item) => item.id == childId);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_editingChildId == null ? '子ども作成' : '子ども編集'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'ニックネーム',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _traitsMemoController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: '特性メモ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
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
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
