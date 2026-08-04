import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/pages/register/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('RegisterForm - Renderizado', () {
    testWidgets('Los campos de entrada y el botón de registro son visibles', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: RegisterForm(onSubmit: (_) async {}),
        ),
      );

      expect(find.bySubtype<UsernameField>(), findsOneWidget);
      expect(find.bySubtype<EmailField>(), findsOneWidget);
      expect(find.bySubtype<PasswordField>(), findsNWidgets(2));
      expect(find.bySubtype<AppButton>(), findsOneWidget);
    });
  });

  group('RegisterForm - Validación', () {
    testWidgets('Muestra mensajes de error cuando los campos están vacíos', (tester) async {
      bool onSubmitCalled = false;
      await tester.pumpApp(
        Scaffold(
          body: RegisterForm(
            onSubmit: (_) async {
              onSubmitCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.bySubtype<AppButton>());
      await tester.pumpAndSettle();

      expect(onSubmitCalled, isFalse);
      expect(find.text(AuthStrings.usernameRequired), findsOneWidget);
      expect(find.text(AuthStrings.emailRequired), findsOneWidget);
      expect(find.text(AuthStrings.passwordRequired), findsOneWidget);
      expect(find.text(AuthStrings.confirmPasswordRequired), findsOneWidget);
    });

    testWidgets('Muestra error si las contraseñas no coinciden', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: RegisterForm(onSubmit: (_) async {}),
        ),
      );

      await tester.enterText(find.bySubtype<UsernameField>(), 'user123');
      await tester.enterText(find.bySubtype<EmailField>(), 'test@correo.com');
      await tester.enterText(find.bySubtype<PasswordField>().first, 'Password123!');
      await tester.enterText(find.bySubtype<PasswordField>().last, 'Different123!');

      await tester.tap(find.bySubtype<AppButton>());
      await tester.pumpAndSettle();

      expect(find.text(AuthStrings.passwordsDoNotMatch), findsOneWidget);
    });
  });

  group('RegisterForm - Interacción y Envío', () {
    testWidgets('Limpia espacios en blanco y envía los datos correctos', (tester) async {
      String? capturedUsername;
      String? capturedEmail;
      String? capturedPassword;

      await tester.pumpApp(
        Scaffold(
          body: RegisterForm(
            onSubmit: (data) async {
              capturedUsername = data.username;
              capturedEmail = data.email;
              capturedPassword = data.password;
            },
          ),
        ),
      );

      await tester.enterText(find.bySubtype<UsernameField>(), '  user123  ');
      await tester.enterText(find.bySubtype<EmailField>(), '  test@correo.com  ');
      await tester.enterText(find.bySubtype<PasswordField>().first, 'Password123!');
      await tester.enterText(find.bySubtype<PasswordField>().last, 'Password123!');

      await tester.tap(find.bySubtype<AppButton>());
      await tester.pump();

      expect(capturedUsername, 'user123');
      expect(capturedEmail, 'test@correo.com');
      expect(capturedPassword, 'Password123!');
    });

    testWidgets('Mueve el foco secuencialmente entre los campos al presionar Siguiente', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: RegisterForm(onSubmit: (_) async {}),
        ),
      );

      // Foco inicial en Username
      await tester.tap(find.bySubtype<UsernameField>());
      await tester.pump();

      // Ir a Email
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(_hasFocus<EmailField>(tester), isTrue);

      // Ir a Password
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(_hasFocus<PasswordField>(tester, index: 0), isTrue);

      // Ir a Confirm Password
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(_hasFocus<PasswordField>(tester, index: 1), isTrue);
    });
  });
}

bool _hasFocus<T extends Widget>(WidgetTester tester, {int index = 0}) {
  final widgetFinder = find.bySubtype<T>().at(index);

  final textField = tester.widget<TextField>(
    find.descendant(of: widgetFinder, matching: find.byType(TextField)),
  );

  return textField.focusNode?.hasFocus ?? false;
}
