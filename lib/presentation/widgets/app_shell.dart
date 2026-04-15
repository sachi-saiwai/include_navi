import 'package:flutter/material.dart';

import '../../app/app_scope.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.body,
    this.actions = const <Widget>[],
    this.floatingActionButton,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        scrolledUnderElevation: 0,
        actions: <Widget>[
          ...actions,
          IconButton(
            onPressed: controller.signOut,
            tooltip: 'サインアウト',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFBF9F8))),
          Positioned(
            left: -60,
            top: -30,
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
            right: -30,
            top: 90,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10FFD6C8),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 24,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10CAF9DC),
              ),
            ),
          ),
          SafeArea(child: body),
          if (controller.isBusy)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x22000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
