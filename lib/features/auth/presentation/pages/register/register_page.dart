import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_config_extensions.dart';
import '../../constants/auth_strings.dart';
import '../../extensions/auth_failure_message_extension.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/auth_redirect_link.dart';
import 'providers/register_providers.dart';
import 'providers/register_state.dart';
import 'widgets/register_form.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);

    return AuthPageLayout(
      header: AuthHeader(
        title: ref.appInfo.name,
        subtitle: ref.welcomeTexts.register.subtitle,
      ),
      errorMessage: registerState.maybeWhen(
        failure: (failure) => failure.toAuthMessage(ref.appConfig),
        orElse: () => null,
      ),
      form: RegisterForm(
        onSubmit: (data) {
          final provider = ref.read(registerProvider.notifier);
          return provider.signUp(
            name: data.username,
            email: data.email,
            password: data.password,
          );
        },
        isLoading: registerState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ),
      ),
      switchAuthAction: AuthRedirectLink(
        text: AuthStrings.alreadyHaveAccountText,
        linkText: AuthStrings.loginLink,
        onTap: () => context.pop(),
      ),
    );
  }
}
