import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'app/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabaseIfConfigured();

  final dependencies = AppDependencies.build();
  runApp(IncludeNaviApp(dependencies: dependencies));
}
