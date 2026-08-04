import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('LoginForm - Renderizado', () {
    testWidgets('Los campos de entrada y el botón de acción son visibles', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: LoginForm(onSubmit: (_, _) async {}),
        ),
      );

      expect(find.bySubtype<EmailField>(), findsOneWidget);
      expect(find.bySubtype<PasswordField>(), findsOneWidget);
      expect(find.bySubtype<AppButton>(), findsOneWidget);
    });
  });

  group('LoginForm - Validación', () {
    testWidgets('Muestra mensajes de error cuando los campos están vacíos', (tester) async {
      bool onSubmitCalled = false;
      await tester.pumpApp(
        Scaffold(
          body: LoginForm(
            onSubmit: (_, _) async {
              onSubmitCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.bySubtype<AppButton>());
      await tester.pumpAndSettle();

      expect(onSubmitCalled, isFalse);
      expect(find.text(AuthStrings.emailRequired), findsOneWidget);
      expect(find.text(AuthStrings.passwordRequired), findsOneWidget);
    });
  });

  group('LoginForm - Interacción y Envío', () {
    testWidgets('Limpia los espacios en blanco del correo al enviar el formulario', (tester) async {
      String? capturedEmail;
      String? capturedPassword;

      await tester.pumpApp(
        Scaffold(
          body: LoginForm(
            onSubmit: (email, password) async {
              capturedEmail = email;
              capturedPassword = password;
            },
          ),
        ),
      );

      await tester.enterText(find.bySubtype<EmailField>(), '  test@correo.com  ');
      await tester.enterText(find.bySubtype<PasswordField>(), 'Password123!');

      await tester.tap(find.bySubtype<AppButton>());
      await tester.pump();

      expect(capturedEmail, 'test@correo.com');
      expect(capturedPassword, 'Password123!');
    });

    testWidgets('Mueve el foco al campo de contraseña al completar el correo', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: LoginForm(onSubmit: (_, _) async {}),
        ),
      );

      await tester.tap(find.bySubtype<EmailField>());
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      final passwordFieldFinder = find.bySubtype<PasswordField>();
      final textField = tester.widget<TextField>(
        find.descendant(of: passwordFieldFinder, matching: find.byType(TextField)),
      );

      expect(textField.focusNode?.hasFocus, isTrue, reason: 'El campo de contraseña debería tener el foco');
    });
  });
}
