import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/constants/auth_test_keys.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
import 'package:eventix/features/auth/presentation/pages/register/register_page.dart';
import 'package:eventix/features/events/presentation/pages/event_list/event_list_page.dart';
import 'package:eventix/main_common.dart';
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

  late String testEmail;

  setUp(() async {
    await auth.signOut();

    testEmail = 'register_${DateTime.now().microsecondsSinceEpoch}@example.com';
  });

  tearDown(() async {
    await deleteTestUser(
      auth: auth,
      email: testEmail,
      password: IntegrationTestConstants.testPassword,
    );
  });

  testWidgets('Registra un usuario y redirige al home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EventixApp()));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.tap(find.text(AuthStrings.registerLink));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(RegisterPage), findsOneWidget);

    await tester.enterText(
      find.byKey(AuthTestKeys.registerUsernameField),
      IntegrationTestConstants.registrationUsername,
    );
    await tester.enterText(
      find.byKey(AuthTestKeys.registerEmailField),
      testEmail,
    );
    await tester.enterText(
      find.byKey(AuthTestKeys.registerPasswordField),
      IntegrationTestConstants.testPassword,
    );
    await tester.enterText(
      find.byKey(AuthTestKeys.registerConfirmPasswordField),
      IntegrationTestConstants.testPassword,
    );

    await tester.tap(find.byKey(AuthTestKeys.registerButton));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(EventListPage), findsOneWidget);
  });
}
