import 'package:flutter/material.dart';

import '../application/app_controller.dart';
import '../presentation/screens/child_form_screen.dart';
import '../presentation/screens/child_list_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/record_detail_screen.dart';
import '../presentation/screens/record_form_screen.dart';
import '../presentation/screens/record_list_screen.dart';
import '../presentation/screens/reflection_screen.dart';
import '../presentation/screens/sharing_screen.dart';
import 'app_scope.dart';
import 'dependencies.dart';

class IncludeNaviApp extends StatefulWidget {
  const IncludeNaviApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<IncludeNaviApp> createState() => _IncludeNaviAppState();
}

class _IncludeNaviAppState extends State<IncludeNaviApp> {
  late final AppController _controller = widget.dependencies.createController();

  @override
  void initState() {
    super.initState();
    _controller.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: _controller,
      child: MaterialApp(
        title: 'いんくるなび',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF006A6B),
            onPrimary: Colors.white,
            secondary: Color(0xFF9FF0F0),
            onSecondary: Color(0xFF143536),
            error: Color(0xFFB42318),
            onError: Colors.white,
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFF1E2B2C),
          ),
          scaffoldBackgroundColor: const Color(0xFFFBF9F8),
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: const Color(0xFF1E2B2C),
            displayColor: const Color(0xFF1E2B2C),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Color(0xFF1E2B2C),
            titleTextStyle: TextStyle(
              color: Color(0xFF1E2B2C),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shadowColor: const Color(0x110E3A3C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: const BorderSide(color: Color(0xFFE9E5E3)),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFFCAF9DC),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF006A6B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF006A6B),
              side: const BorderSide(color: Color(0xFFD8E3E0)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF006A6B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
          ),
          useMaterial3: true,
        ),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          ChildListScreen.routeName: (context) => const ChildListScreen(),
          ChildFormScreen.routeName: (context) => const ChildFormScreen(),
          RecordListScreen.routeName: (context) => const RecordListScreen(),
          RecordFormScreen.routeName: (context) => const RecordFormScreen(),
          RecordDetailScreen.routeName: (context) => const RecordDetailScreen(),
          ReflectionScreen.routeName: (context) => const ReflectionScreen(),
          SharingScreen.routeName: (context) => const SharingScreen(),
        },
        home: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.currentUser == null) {
              return const LoginScreen();
            }
            return const ChildListScreen();
          },
        ),
      ),
    );
  }
}
