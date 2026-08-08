import 'dart:async';

import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/router/app_router.dart';
import 'package:eventix/core/router/app_routes.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
import 'package:eventix/features/auth/presentation/pages/register/register_page.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:eventix/features/events/presentation/pages/event_list/event_list_page.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/list/events_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

/// Notificador simulado para evitar efectos secundarios (API/DB)
/// durante la verificación de rutas.
class MockEventsNotifier extends EventsNotifier {
  @override
  Future<List<EventEntity>> build() async {
    return [];
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late GoRouter router;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();

    // Silenciamos el stream de auth por defecto para evitar estados indeterminados
    when(
      () => mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => const Stream.empty());
  });

  group('AppRouter - Cableado de Pantallas', () {
    testWidgets('La ruta login renderiza correctamente LoginPage', (
      tester,
    ) async {
      await tester.pumpApp(
        Consumer(
          builder: (context, ref, _) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(routerConfig: router);
          },
        ),
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          authStateChangesProvider.overrideWithValue(
            const AsyncValue.data(null),
          ),
        ],
        wrapWithMaterialApp: false,
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('La ruta register renderiza correctamente RegisterPage', (
      tester,
    ) async {
      await tester.pumpApp(
        Consumer(
          builder: (context, ref, _) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(routerConfig: router);
          },
        ),
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          authStateChangesProvider.overrideWithValue(
            const AsyncValue.data(null),
          ),
        ],
        wrapWithMaterialApp: false,
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.register);
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets(
      'La ruta de eventos renderiza EventListPage dentro del Shell para usuarios autenticados',
      (tester) async {
        await tester.pumpApp(
          Consumer(
            builder: (context, ref, _) {
              router = ref.watch(appRouterProvider);
              return MaterialApp.router(routerConfig: router);
            },
          ),
          overrides: [
            firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
            authStateChangesProvider.overrideWithValue(
              AsyncValue.data(MockUser()),
            ),
            eventsProvider.overrideWith(MockEventsNotifier.new),
          ],
          wrapWithMaterialApp: false,
        );
        await tester.pumpAndSettle();

        expect(find.byType(EventListPage), findsOneWidget);
      },
    );
  });

  group('StreamToListenable - Notificaciones y Ciclo de Vida', () {
    test(
      'El listenable notifica a sus oyentes al recibir eventos del flujo',
      () async {
        final controller = StreamController<User?>.broadcast();
        final notified = Completer<void>();
        int callCount = 0;

        final listenable = StreamToListenable(controller.stream)
          ..addListener(() {
            callCount++;
            if (!notified.isCompleted) {
              notified.complete();
            }
          });

        controller.add(null);
        await notified.future;

        expect(callCount, equals(1));

        listenable.dispose();
        await controller.close();
      },
    );

    test(
      'Se genera una notificación única por cada emisión del flujo',
      () async {
        final controller = StreamController<User?>.broadcast();
        final notified = Completer<void>();
        int callCount = 0;

        final listenable = StreamToListenable(controller.stream)
          ..addListener(() {
            callCount++;
            if (callCount == 3 && !notified.isCompleted) {
              notified.complete();
            }
          });

        controller
          ..add(null)
          ..add(MockUser())
          ..add(null);

        await notified.future;

        expect(callCount, equals(3));

        listenable.dispose();
        await controller.close();
      },
    );

    test(
      'Los oyentes dejan de recibir notificaciones tras invocar dispose',
      () async {
        final controller = StreamController<User?>.broadcast();
        int callCount = 0;

        final listenable = StreamToListenable(controller.stream)
          ..addListener(() => callCount++);

        listenable.dispose();

        controller.add(null);

        expect(callCount, equals(0));

        await controller.close();
      },
    );

    test(
      'La suscripción al flujo se cancela automáticamente al liberar el objeto',
      () async {
        final canceled = Completer<void>();
        final controller = StreamController<User?>.broadcast(
          onCancel: () {
            if (!canceled.isCompleted) {
              canceled.complete();
            }
          },
        );
        final listenable = StreamToListenable(controller.stream);

        expect(controller.hasListener, isTrue);

        listenable.dispose();
        await canceled.future;

        expect(controller.hasListener, isFalse);

        await controller.close();
      },
    );
  });
}
