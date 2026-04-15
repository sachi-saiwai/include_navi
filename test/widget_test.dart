import 'package:flutter_test/flutter_test.dart';

import 'package:include_navi/app/app.dart';
import 'package:include_navi/app/dependencies.dart';

void main() {
  testWidgets('login screen is shown before sign in', (tester) async {
    await tester.pumpWidget(
      IncludeNaviApp(dependencies: AppDependencies.build()),
    );

    expect(find.text('いんくるなび'), findsOneWidget);
    expect(find.text('Googleでログイン / Demoで続行'), findsOneWidget);
  });
}
