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
            primary: Color(0xFF0E7490),
            onPrimary: Colors.white,
            secondary: Color(0xFFF59E0B),
            onSecondary: Color(0xFF1F2937),
            error: Color(0xFFB42318),
            onError: Colors.white,
            surface: Color(0xFFFFFCF7),
            onSurface: Color(0xFF172033),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F3EC),
          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: const Color(0xFF172033),
                displayColor: const Color(0xFF172033),
              ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Color(0xFF172033),
            titleTextStyle: TextStyle(
              color: Color(0xFF172033),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFE4E1D7)),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFFE8F4F3),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0E7490),
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
              foregroundColor: const Color(0xFF0E7490),
              side: const BorderSide(color: Color(0xFFD6DFE3)),
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
            backgroundColor: Color(0xFF0E7490),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
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
