import 'dart:async';

import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/router/app_router.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:eventix/features/events/presentation/pages/event_list/event_list_page.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/list/events_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockEventsNotifier extends EventsNotifier {
  @override
  Future<List<EventEntity>> build() async => [];
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late StreamController<User?> authController;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authController = StreamController<User?>.broadcast();

    when(
      () => mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => authController.stream);
  });

  tearDown(() async {
    await authController.close();
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        eventsProvider.overrideWith(MockEventsNotifier.new),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
  }

  testWidgets(
    'redirige desde login al home cuando el servicio de auth emite un usuario autenticado',
    (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      authController.add(null);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);

      authController.add(MockUser());
      await tester.pumpAndSettle();

      expect(find.byType(EventListPage), findsOneWidget);
    },
  );
}
