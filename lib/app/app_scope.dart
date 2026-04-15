import 'package:flutter/widgets.dart';

import '../application/app_controller.dart';

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    required this.controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  final AppController controller;

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.controller;
  }
}
