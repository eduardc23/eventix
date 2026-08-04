import 'dart:async';

import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/auth/domain/failures/auth_failure.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/extensions/auth_failure_message_extension.dart';
import 'package:eventix/features/auth/presentation/pages/login/login_page.dart';
import 'package:eventix/features/auth/presentation/pages/login/providers/login_providers.dart';
import 'package:eventix/features/auth/presentation/pages/login/providers/login_state.dart';
import 'package:eventix/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  late MockSignInUseCase mockSignInUseCase;

  setUpAll(() {
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
  });

  group('LoginPage - Estado Inicial', () {
    testWidgets('El subtítulo de login es visible', (tester) async {
      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      expect(find.text(AuthStrings.loginSubtitle), findsOneWidget);
    });

    testWidgets('LoginForm es visible', (tester) async {
      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets('El texto de registro y el link son visibles', (tester) async {
      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      expect(find.text(AuthStrings.noAccountText), findsOneWidget);
      expect(find.text(AuthStrings.registerLink), findsOneWidget);
    });

    testWidgets('No se muestra ningún mensaje de error al inicio', (tester) async {
      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      expect(
        find.text(FakeAppFailure().toAuthMessage),
        findsNothing,
      );
    });
  });

  group('LoginPage - Comportamiento (Patrón de Booking)', () {
    testWidgets('Muestra el estado de carga al intentar iniciar sesión', (tester) async {
      final completer = Completer<Result<void, AppFailure>>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(const Success(null));
        }
      });

      // Mock que no completa inmediatamente para poder capturar el estado de carga
      when(() => mockSignInUseCase(any())).thenAnswer(
            (_) => completer.future,
      );

      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text(AuthStrings.loginButton));
      await tester.pump();

      final form = tester.widget<LoginForm>(find.byType(LoginForm));
      expect(form.isLoading, isTrue);
    });

    testWidgets('Muestra mensaje de error cuando el login falla', (tester) async {
      final failure = FakeAppFailure();
      when(() => mockSignInUseCase(any())).thenAnswer((_) async => Error(failure));

      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          signInUseCaseProvider.overrideWithValue(mockSignInUseCase),
        ],
      );

      await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text(AuthStrings.loginButton));

      await tester.pump(); // Dispara la acción y pasa a loading
      await tester.pump(); // Resuelve el mock y actualiza UI

      expect(find.text(failure.toAuthMessage), findsOneWidget);
      verify(() => mockSignInUseCase(any())).called(1);
    });
  });

  group('LoginPage - Estado Manual (Para testeo rápido de UI)', () {
    testWidgets('El mensaje se actualiza cuando el error cambia', (tester) async {
      final firstFailure = FakeAppFailure();
      final secondFailure = AuthFailure.invalidCredentials();

      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          loginProvider.overrideWithValue(LoginState.failure(failure: firstFailure)),
        ],
      );
      expect(find.text(firstFailure.toAuthMessage), findsOneWidget);

      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          loginProvider.overrideWithValue(LoginState.failure(failure: secondFailure)),
        ],
      );
      await tester.pump();

      expect(find.text(secondFailure.toAuthMessage), findsOneWidget);
      expect(find.text(firstFailure.toAuthMessage), findsNothing);
    });
  });
}
