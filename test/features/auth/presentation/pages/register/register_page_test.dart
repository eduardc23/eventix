import 'dart:async';

import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/auth/domain/failures/auth_failure.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/extensions/auth_failure_message_extension.dart';
import 'package:eventix/features/auth/presentation/pages/register/providers/register_providers.dart';
import 'package:eventix/features/auth/presentation/pages/register/providers/register_state.dart';
import 'package:eventix/features/auth/presentation/pages/register/register_page.dart';
import 'package:eventix/features/auth/presentation/pages/register/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_app_config.dart';

void main() {
  late MockSignUpUseCase mockSignUpUseCase;

  setUpAll(() {
    registerFallbackValue(
      const SingUpParams(name: '', email: '', password: ''),
    );
  });

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
  });

  group('RegisterPage - Estado Inicial', () {
    testWidgets('El subtítulo de registro es visible', (tester) async {
      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      expect(
        find.text(testAppConfig.welcomeTexts.register.subtitle),
        findsOneWidget,
      );
    });

    testWidgets('RegisterForm es visible', (tester) async {
      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      expect(find.byType(RegisterForm), findsOneWidget);
    });

    testWidgets('El texto de redirección a login y el link son visibles', (
      tester,
    ) async {
      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      expect(find.text(AuthStrings.alreadyHaveAccountText), findsOneWidget);
      expect(find.text(AuthStrings.loginLink), findsOneWidget);
    });

    testWidgets('No se muestra ningún mensaje de error al inicio', (
      tester,
    ) async {
      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      expect(find.text(FakeAppFailure().toAuthMessage(testAppConfig)), findsNothing);
    });
  });

  group('RegisterPage - Comportamiento (Patrón de Booking)', () {
    testWidgets('Muestra el estado de carga al intentar registrarse', (
      tester,
    ) async {
      final completer = Completer<Result<void, AuthFailure>>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(const Success(null));
        }
      });

      when(() => mockSignUpUseCase(any())).thenAnswer((_) => completer.future);

      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');

      await tester.tap(find.text(AuthStrings.registerButton));
      await tester.pump();

      final form = tester.widget<RegisterForm>(find.byType(RegisterForm));
      expect(form.isLoading, isTrue);
    });

    testWidgets('Muestra mensaje de error cuando el registro falla', (
      tester,
    ) async {
      final failure = FakeAppFailure();
      when(
        () => mockSignUpUseCase(any()),
      ).thenAnswer((_) async => Error(failure));

      await tester.pumpApp(
        const RegisterPage(),
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@test.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');

      await tester.tap(find.text(AuthStrings.registerButton));

      await tester.pump(); // Loading
      await tester.pump(); // Error

      expect(find.text(failure.toAuthMessage(testAppConfig)), findsOneWidget);
      verify(() => mockSignUpUseCase(any())).called(1);
    });
  });

  group('RegisterPage - Estado Manual (Para testeo rápido de UI)', () {
    testWidgets('El mensaje se actualiza cuando el error cambia', (
      tester,
    ) async {
      final firstFailure = AuthFailure.emailAlreadyInUse();
      final secondFailure = AuthFailure.unexpected();

      await tester.pumpApp(
        const RegisterPage(),
        overrides: [
          registerProvider.overrideWithValue(
            RegisterState.failure(failure: firstFailure),
          ),
        ],
      );
      expect(find.text(firstFailure.toAuthMessage(testAppConfig)), findsOneWidget);

      await tester.pumpApp(
        const RegisterPage(),
        overrides: [
          registerProvider.overrideWithValue(
            RegisterState.failure(failure: secondFailure),
          ),
        ],
      );
      await tester.pump();

      expect(find.text(secondFailure.toAuthMessage(testAppConfig)), findsOneWidget);
      expect(find.text(firstFailure.toAuthMessage(testAppConfig)), findsNothing);
    });
  });
}
