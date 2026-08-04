import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('SplashPage', () {
    testWidgets('renderiza el indicador de carga en la pantalla de splash', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const SplashPage());

      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
