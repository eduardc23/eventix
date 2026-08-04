import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/auth/presentation/constants/auth_test_keys.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
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
  await configureFirebaseEmulators(
    auth: auth,
    firestore: FirebaseFirestore.instance,
  );

  late String testEmail;

  setUp(() async {
    await auth.signOut();
    testEmail = await createAndSignInTestUser(
      auth: auth,
      prefix: 'test',
      password: IntegrationTestConstants.testPassword,
    );
    await auth.signOut();
  });

  tearDown(() async {
    await auth.signOut();
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
  });

  testWidgets('Redirige al listado de eventos tras iniciar sesión', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(AuthTestKeys.emailField), testEmail);
    await tester.enterText(
      find.byKey(AuthTestKeys.passwordField),
      IntegrationTestConstants.testPassword,
    );
    await tester.tap(find.byKey(AuthTestKeys.loginButton));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(EventListPage), findsOneWidget);
  });
}
