import 'package:app_ui_kit/app_ui_kit.dart';

import 'package:flutter/material.dart';

import '../../../constants/auth_strings.dart';
import '../../../constants/auth_test_keys.dart';
import '../../../validators/auth_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSubmit, this.isLoading = false});

  /// Callback con email y contraseña validados al hacer submit.
  final Future<void> Function(String email, String password) onSubmit;

  /// Muestra un indicador de carga en el botón y deshabilita el formulario.
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailField(
            key: AuthTestKeys.emailField,
            controller: _emailController,
            focusNode: _emailFocus,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passwordFocus.requestFocus(),
            validator: AuthValidators.email,
          ),
          AppSpacing.md.vGap,
          PasswordField(
            key: AuthTestKeys.passwordField,
            controller: _passwordController,
            focusNode: _passwordFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
            validator: AuthValidators.password,
          ),
          AppSpacing.xl.vGap,
          AppButton.primary(
            key: AuthTestKeys.loginButton,
            label: AuthStrings.loginButton,
            isLoading: widget.isLoading,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
