import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/shell/presentation/constants/main_shell_strings.dart';
import 'package:eventix/features/shell/presentation/pages/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_app_config.dart';

void main() {
  Future<void> pumpMainShell(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, _) => const SizedBox(key: Key('events_page')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/bookings',
                  builder: (_, _) => const SizedBox(key: Key('bookings_page')),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.pumpApp(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
      overrides: overrides,
      wrapWithMaterialApp: false,
    );
    await tester.pumpAndSettle();
  }

  group('MainShell', () {
    testWidgets('Renderiza la barra de navegación y las etiquetas', (
      WidgetTester tester,
    ) async {
      await pumpMainShell(tester);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text(testAppConfig.sections.events), findsOneWidget);
      expect(find.text(testAppConfig.sections.myBookings), findsOneWidget);
    });

    testWidgets('Cambia de rama al seleccionar un destino', (
      WidgetTester tester,
    ) async {
      await pumpMainShell(tester);

      // Estamos en la página de eventos
      expect(find.byKey(const Key('events_page')), findsOneWidget);
      expect(find.byKey(const Key('bookings_page')), findsNothing);

      // Pulsamos en Mis reservas
      await tester.tap(find.text(testAppConfig.sections.myBookings));
      await tester.pumpAndSettle();

      // Deberíamos estar en la página de reservas
      expect(find.byKey(const Key('events_page')), findsNothing);
      expect(find.byKey(const Key('bookings_page')), findsOneWidget);

      // Volver a eventos
      await tester.tap(find.text(testAppConfig.sections.events));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('events_page')), findsOneWidget);
    });

    testWidgets('llama al cierre de sesión al pulsar en el drawer', (
      WidgetTester tester,
    ) async {
      final mockSignOutUseCase = MockSignOutUseCase();
      when(() => mockSignOutUseCase.call()).thenAnswer(
        (_) async => const Success(null),
      );

      await pumpMainShell(tester, overrides: [
        signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
      ]);

      // Abrir el drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Pulsar cerrar sesión
      await tester.tap(find.text(MainShellStrings.signOutLabel));
      await tester.pump();

      verify(() => mockSignOutUseCase.call()).called(1);
    });

    testWidgets('Muestra un snackbar cuando ocurre un error al cerrar sesión', (
      WidgetTester tester,
    ) async {
      final mockSignOutUseCase = MockSignOutUseCase();
      final failure = FakeAppFailure();

      when(() => mockSignOutUseCase.call()).thenAnswer(
        (_) async => Error(failure),
      );

      await pumpMainShell(tester, overrides: [
        signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
      ]);

      // Abrir el drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Pulsar cerrar sesión
      await tester.tap(find.text(MainShellStrings.signOutLabel));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(MainShellStrings.signOutError), findsOneWidget);
    });
  });
}
