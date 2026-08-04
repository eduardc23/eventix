import 'package:cloud_firestore/cloud_firestore.dart';
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

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  await configureFirebaseEmulators(auth: auth, firestore: firestore);

  setUp(() async {
    await auth.signOut();
    await resetIntegrationTestData(firestore: firestore, clearEvents: true);

    await createAndSignInTestUser(
      auth: auth,
      prefix: 'home',
      password: IntegrationTestConstants.testPassword,
    );
    await seedEvent(
      firestore: firestore,
      title: IntegrationTestConstants.eventTitle,
    );
  });

  tearDown(() async {
    await auth.signOut();
    await resetIntegrationTestData(firestore: firestore, clearEvents: true);

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
  });

  testWidgets(
    'al entrar al home se cargan los eventos y se muestran en pantalla',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(EventListPage), findsOneWidget);
      expect(find.text(IntegrationTestConstants.eventTitle), findsOneWidget);
    },
  );
}
