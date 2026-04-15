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
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFF7F3EC),
                    Color(0xFFF3F7F6),
                    Color(0xFFFFFCF7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            left: -80,
            top: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1A0E7490),
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14F59E0B),
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
