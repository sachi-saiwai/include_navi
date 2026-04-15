import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import 'child_form_screen.dart';
import 'record_list_screen.dart';
import '../widgets/app_shell.dart';
import '../widgets/message_banner.dart';

class ChildListScreen extends StatelessWidget {
  const ChildListScreen({super.key});

  static const routeName = '/children';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final hasChildren = controller.childProfiles.isNotEmpty;

    return AppShell(
      title: 'ホーム',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(ChildFormScreen.routeName);
        },
        label: const Text('子どもを追加'),
        icon: const Icon(Icons.person_add_alt_1),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadChildProfiles,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const MessageBanner(),
                    _HomeHero(
                      displayName: controller.currentUser?.displayName ?? '未設定',
                      email: controller.currentUser?.email ?? 'メール未設定',
                      childCount: controller.childProfiles.length,
                      onAddChild: () {
                        Navigator.of(context).pushNamed(ChildFormScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 16),
                    _QuickGuide(hasChildren: hasChildren),
                    const SizedBox(height: 16),
                    if (!hasChildren)
                      _EmptyChildState(
                        onAddChild: () {
                          Navigator.of(context).pushNamed(ChildFormScreen.routeName);
                        },
                      )
                    else ...<Widget>[
                      Text(
                        '登録した子ども',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ...controller.childProfiles.map(
                        (child) => Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () async {
                              await controller.selectChild(child.id);
                              if (!context.mounted) {
                                return;
                              }
                              Navigator.of(context).pushNamed(RecordListScreen.routeName);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: <Color>[
                                          Color(0xFFD9F0EE),
                                          Color(0xFFF6E8C8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.child_care,
                                      color: Color(0xFF0E7490),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                child.nickname.isEmpty ? 'ニックネーム未入力' : child.nickname,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                              ),
                                            ),
                                            const Chip(label: Text('プロフィール')),
                                          ],
                                        ),
                                        Text(
                                          child.traitsMemo.isEmpty ? '特性メモ未入力' : child.traitsMemo,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                height: 1.6,
                                                color: const Color(0xFF4A5565),
                                              ),
                                        ),
                                        const SizedBox(height: 14),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: <Widget>[
                                            FilledButton.tonalIcon(
                                              onPressed: () async {
                                                await controller.selectChild(child.id);
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                Navigator.of(context).pushNamed(RecordListScreen.routeName);
                                              },
                                              icon: const Icon(Icons.menu_book),
                                              label: const Text('記録を見る'),
                                            ),
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  ChildFormScreen.routeName,
                                                  arguments: child.id,
                                                );
                                              },
                                              icon: const Icon(Icons.edit),
                                              label: const Text('プロフィール編集'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.displayName,
    required this.email,
    required this.childCount,
    required this.onAddChild,
  });

  final String displayName;
  final String email;
  final int childCount;
  final VoidCallback onAddChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF123B54),
            Color(0xFF0E7490),
            Color(0xFF1497B8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x26123B54),
            blurRadius: 30,
            offset: Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'ホーム / 子どもプロフィール管理',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'まずは子どもを登録して、\n毎日の記録を始めましょう。',
            style: theme.textTheme.headlineSmall?.copyWith(
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'この画面がホームです。子どもを追加すると、記録一覧・記録入力・振り返りへ進めます。',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: const Color(0xFFE5F9FD),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: onAddChild,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('子どもを追加する'),
              ),
              _InfoPill(
                icon: Icons.family_restroom,
                label: '登録済み $childCount人',
              ),
              _InfoPill(
                icon: Icons.account_circle,
                label: displayName,
                secondary: email,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyChildState extends StatelessWidget {
  const _EmptyChildState({required this.onAddChild});

  final VoidCallback onAddChild;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color(0xFFF7E6BC),
                        Color(0xFFF3C96B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: Color(0xFF704B00)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'まだ子どもプロフィールがありません',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ホームから先へ進むには、最初に子どもを1人登録します。登録後はその子の記録一覧へ移動できます。',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('次のステップ', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  Text('1. 「子どもを追加する」を押す'),
                  SizedBox(height: 6),
                  Text('2. ニックネームと特性メモを保存する'),
                  SizedBox(height: 6),
                  Text('3. 作成した子どもを開いて記録一覧へ進む'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAddChild,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('子どもを追加する'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickGuide extends StatelessWidget {
  const _QuickGuide({required this.hasChildren});

  final bool hasChildren;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 760;
        final children = <Widget>[
          _GuideCard(
            icon: Icons.looks_one_rounded,
            title: '子どもを登録',
            description: 'ニックネームと特性メモを保存して、記録の対象を作ります。',
            accent: const Color(0xFFE8F4F3),
          ),
          _GuideCard(
            icon: Icons.looks_two_rounded,
            title: '記録をためる',
            description: '毎日のコンディションやできごとをABC形式で残します。',
            accent: const Color(0xFFFFF1D6),
          ),
          _GuideCard(
            icon: Icons.looks_3_rounded,
            title: hasChildren ? '振り返りへ進める状態です' : '登録後に振り返りへ',
            description: '記録一覧から詳細やPDF出力、振り返り画面へつながります。',
            accent: const Color(0xFFEAEAFE),
          ),
        ];

        if (isNarrow) {
          return Column(
            children: children
                .expand((widget) => <Widget>[widget, const SizedBox(height: 12)])
                .toList()
              ..removeLast(),
          );
        }

        return Row(
          children: children
              .expand((widget) => <Widget>[Expanded(child: widget), const SizedBox(width: 12)])
              .toList()
            ..removeLast(),
        );
      },
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF172033)),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: const Color(0xFF4A5565),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    this.secondary,
  });

  final IconData icon;
  final String label;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: const Color(0xFF1C6E8C)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(label),
              if (secondary != null)
                Text(
                  secondary!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
