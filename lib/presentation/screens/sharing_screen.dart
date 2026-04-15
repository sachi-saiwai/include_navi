import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../widgets/app_shell.dart';

class SharingScreen extends StatefulWidget {
  const SharingScreen({super.key});

  static const routeName = '/sharing';

  @override
  State<SharingScreen> createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  final _invitedUserController = TextEditingController();

  @override
  void dispose() {
    _invitedUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return AppShell(
      title: '招待 / 共有',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '共有前提',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('招待された人だけが閲覧可能という前提を維持するため、閲覧対象は Invitation を介して管理します。'),
                  const SizedBox(height: 8),
                  const Text('TODO: 招待フロー詳細、招待単位、先生がアプリ内閲覧かPDFのみかは未定です。'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '先生を招待',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('MVPでは invitedUserId を直接保存する土台のみ実装しています。'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _invitedUserController,
                    decoration: const InputDecoration(
                      labelText: 'invitedUserId',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      await controller.saveInvitation(
                        invitedUserId: _invitedUserController.text.trim(),
                      );
                      _invitedUserController.clear();
                    },
                    child: const Text('招待情報を保存'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '保存済み招待',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (controller.selectedChildInvitations.isEmpty)
                    const Text('招待情報はまだありません。')
                  else
                    ...controller.selectedChildInvitations.map(
                      (invitation) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.mail_outline),
                        title: Text(invitation.invitedUserId),
                        subtitle: Text('作成日時: ${_formatDateTime(invitation.createdAt)}'),
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

String _formatDateTime(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.year}-$month-$day $hour:$minute';
}
