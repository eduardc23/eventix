import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
import 'package:eventix/features/events/presentation/pages/event_list/event_list_page.dart';
import 'package:eventix/features/shell/presentation/constants/main_shell_strings.dart';
import 'package:eventix/main_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/integration_test_constants.dart';
import 'helpers/integration_test_helpers.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await initializeIntegrationTestEnvironment();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  await configureFirebaseEmulators(auth: auth, firestore: firestore);

  setUp(() async {
    await auth.signOut();

    await createAndSignInTestUser(
      auth: auth,
      prefix: 'logout',
      password: IntegrationTestConstants.testPassword,
    );
    await seedEvent(
      firestore: firestore,
      title: IntegrationTestConstants.eventTitle,
    );
  });

  tearDown(() async {
    await deleteTestUser(
      auth: auth,
      password: IntegrationTestConstants.testPassword,
    );
  });

  testWidgets('cierra la sesión desde el home y redirige al login', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: EventixApp()));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(EventListPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text(MainShellStrings.signOutLabel));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
