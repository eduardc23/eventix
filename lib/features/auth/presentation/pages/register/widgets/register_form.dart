import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../constants/auth_strings.dart';
import '../../../constants/auth_test_keys.dart';
import '../../../models/register_form_data.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

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
            key: AuthTestKeys.registerUsernameField,
            controller: _usernameController,
            focusNode: _usernameFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _emailFocus.requestFocus(),
            validator: AuthValidators.username,
          ),
          AppSpacing.md.vGap,
          EmailField(
            key: AuthTestKeys.registerEmailField,
            controller: _emailController,
            focusNode: _emailFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _passwordFocus.requestFocus(),
            validator: AuthValidators.email,
          ),
          AppSpacing.md.vGap,
          PasswordField(
            key: AuthTestKeys.registerPasswordField,
            controller: _passwordController,
            focusNode: _passwordFocus,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            validator: AuthValidators.password,
          ),
          AppSpacing.md.vGap,
          PasswordField(
            key: AuthTestKeys.registerConfirmPasswordField,
            label: AuthStrings.confirmPasswordLabel,
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            onSubmitted: (_) => _handleSubmit(),
            validator: (value) =>
                AuthValidators.confirmPassword(value, _passwordController.text),
          ),
          AppSpacing.xl.vGap,
          AppButton.primary(
            key: AuthTestKeys.registerButton,
            label: AuthStrings.registerButton,
            isLoading: widget.isLoading,
            loadingSemanticsLabel: AuthStrings.loadingRegister,
            onPressed: widget.isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }
}
