import 'package:flutter/widgets.dart';

class AuthTestKeys {
  AuthTestKeys._();

  static const Key emailField = Key('auth.login.emailField');
  static const Key passwordField = Key('auth.login.passwordField');
  static const Key loginButton = Key('auth.login.submitButton');

  static const Key registerUsernameField = Key('auth.register.usernameField');
  static const Key registerEmailField = Key('auth.register.emailField');
  static const Key registerPasswordField = Key('auth.register.passwordField');
  static const Key registerConfirmPasswordField =
      Key('auth.register.confirmPasswordField');
  static const Key registerButton = Key('auth.register.submitButton');
}
