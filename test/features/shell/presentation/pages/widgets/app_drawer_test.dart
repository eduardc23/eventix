import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/features/shell/presentation/constants/main_shell_strings.dart';
import 'package:eventix/features/shell/presentation/pages/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('AppDrawer - Renderizado', () {
    testWidgets('Muestra el nombre de la aplicación en el encabezado', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: AppDrawer(onSignOut: () {}),
        ),
      );

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.text(AppConstants.appName), findsOneWidget);
    });

    testWidgets('Visualiza la opción de cierre de sesión con su etiqueta e ícono', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: AppDrawer(onSignOut: () {}),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text(MainShellStrings.signOutLabel), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });

  group('AppDrawer - Interacción', () {
    testWidgets(
      'Llama al callback onSignOut al presionar la opción de cerrar sesión',
      (WidgetTester tester) async {
        int signOutCallCount = 0;

        await tester.pumpApp(
          Scaffold(
            body: AppDrawer(
              onSignOut: () => signOutCallCount++,
            ),
          ),
        );

        final signOutTile = find.widgetWithText(
          ListTile,
          MainShellStrings.signOutLabel,
        );

        await tester.tap(signOutTile);
        await tester.pumpAndSettle();

        expect(signOutCallCount, 1);
      },
    );
  });
}
