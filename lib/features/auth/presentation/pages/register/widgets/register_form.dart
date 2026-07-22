import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../constants/auth_strings.dart';
import '../../../validators/auth_validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Callback con los datos validados al hacer submit.
  final Future<void> Function(RegisterFormData data) onSubmit;

  /// Muestra un indicador de carga en el botón y deshabilita el formulario.
  final bool isLoading;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      RegisterFormData(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UsernameField(
            controller: _usernameController,
            focusNode: _usernameFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _emailFocus.requestFocus(),
            validator: AuthValidators.username,
          ),
          AppSpacing.md.vGap,
          EmailField(
            controller: _emailController,
            focusNode: _emailFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _passwordFocus.requestFocus(),
            validator: AuthValidators.email,
          ),
          AppSpacing.md.vGap,
          PasswordField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            validator: AuthValidators.password,
          ),
          AppSpacing.md.vGap,
          PasswordField(
            label: AuthStrings.confirmPasswordLabel,
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _handleSubmit(),
            validator: (value) => AuthValidators.confirmPassword(
              value,
              _passwordController.text,
            ),
          ),
          AppSpacing.xl.vGap,
          AppButton.primary(
            label: AuthStrings.registerButton,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }
}

/// Modelo de datos que agrupa los valores del formulario de registro.
class RegisterFormData {
  const RegisterFormData({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;
}
