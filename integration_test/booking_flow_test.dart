import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/core/config/app_config_loader.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/presentation/constants/booking_test_keys.dart';
import 'package:eventix/features/booking/presentation/pages/booking/booking_page.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/booking_list_page.dart';
import 'package:eventix/features/events/presentation/constants/events_test_keys.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/event_detail_page.dart';
import 'package:eventix/features/events/presentation/pages/event_list/event_list_page.dart';
import 'package:eventix/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/integration_test_constants.dart';
import 'helpers/integration_test_helpers.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await initializeIntegrationTestEnvironment();
  final configResult = await AppConfigLoader.load();
  final config = switch (configResult) {
    Success(:final value) => value,
    Error(:final error) => throw Exception(
      'No se pudo cargar la configuración en tests: $error',
    ),
  };

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  await configureFirebaseEmulators(auth: auth, firestore: firestore);
  const testEventId = 'integration-test-event';

  setUp(() async {
    await auth.signOut();
    await resetIntegrationTestData(
      firestore: firestore,
      clearEvents: true,
      clearBookings: true,
    );

    await createAndSignInTestUser(
      auth: auth,
      prefix: 'booking',
      password: IntegrationTestConstants.testPassword,
    );
    await seedEvent(
      firestore: firestore,
      title: IntegrationTestConstants.eventTitle,
      eventId: testEventId,
    );
  });

  tearDown(() async {
    await resetIntegrationTestData(
      firestore: firestore,
      clearEvents: true,
      clearBookings: true,
    );

    await deleteTestUser(
      auth: auth,
      password: IntegrationTestConstants.testPassword,
    );
  });

  testWidgets('hace una reserva y redirige al listado de reservas', (
    tester,
  ) async {
    final userId = auth.currentUser?.uid;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue(userId),
          appConfigProvider.overrideWithValue(config),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventListPage), findsOneWidget);

    await tester.tap(find.byKey(EventsTestKeys.eventListItem(testEventId)));
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailPage), findsOneWidget);

    await tester.tap(find.byKey(EventsTestKeys.eventDetailBookingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(BookingPage), findsOneWidget);

    await tester.tap(find.byKey(BookingTestKeys.confirmActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(config.alerts.bookingSuccess.title), findsOneWidget);

    await tester.tap(find.byKey(BookingTestKeys.successDialogOkButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(BookingListPage), findsOneWidget);
  });
}
