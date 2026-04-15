import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../widgets/app_shell.dart';

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  static const routeName = '/reflection';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return AppShell(
      title: '振り返り',
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
                    '振り返り画面の土台',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('対象の子ども: ${controller.selectedChild?.nickname ?? '未選択'}'),
                  const SizedBox(height: 8),
                  Text('記録件数: ${controller.selectedChildRecords.length}'),
                  const SizedBox(height: 12),
                  const Text('TODO: 可視化内容、集計ルール、グラフ有無、期間比較は未定のため未実装です。'),
                  const SizedBox(height: 4),
                  const Text('TODO: ダミー集計や仮グラフは追加していません。'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '導線',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('記録一覧からこの画面へ遷移できます。将来はここに傾向表示コンポーネントを差し込める構成にします。'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
