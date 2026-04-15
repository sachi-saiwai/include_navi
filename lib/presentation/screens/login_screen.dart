import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../application/app_controller.dart';
import '../widgets/message_banner.dart';
import '../widgets/soft_surface_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFBF9F8))),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x109FF0F0),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10FFD6C8),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10CAF9DC),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 860;
                      if (isWide) {
                        return Row(
                          children: <Widget>[
                            Expanded(child: _LoginHero(theme: theme)),
                            const SizedBox(width: 28),
                            Expanded(child: _LoginCard(controller: controller)),
                          ],
                        );
                      }

                      return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _LoginHero(theme: theme),
                          const SizedBox(height: 20),
                          _LoginCard(controller: controller),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: const Color(0xFF006A6B),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14006A6B),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'ABC記録をためる、振り返る',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'いんくるなび',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '親が今日のできごとを記録し、\nあとから傾向を見返すための\n記録アプリです。',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '最初は子どもプロフィールを登録し、その後に毎日の記録一覧や振り返りへ進めます。',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE6FBFB),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const <Widget>[
              _HeroChip(icon: Icons.child_care, label: '子どもプロフィール管理'),
              _HeroChip(icon: Icons.event_note, label: '日々の記録入力'),
              _HeroChip(icon: Icons.insights, label: '振り返り導線つき'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF006A6B),
              border: Border.all(color: const Color(0xFFBEECEC), width: 4),
            ),
            child: const Icon(Icons.favorite_outline, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(
            'ログイン',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Supabase設定が未投入の間は、開発用 demo ユーザーでホーム画面まで進めます。'),
          const SizedBox(height: 18),
          const MessageBanner(),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FFFB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDDEEE6)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('接続メモ', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 10),
                Text('iOS + Supabase 前提のGoogleログイン構成です。'),
                SizedBox(height: 6),
                Text('TODO: 本番利用には Supabase と Google Client ID の実値投入が必要です。'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: controller.signInWithGoogle,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Googleでログイン / Demoで続行'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
