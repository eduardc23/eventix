import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_config_extensions.dart';
import '../../../../../core/router/app_routes.dart';
import '../../constants/auth_strings.dart';
import '../../extensions/auth_failure_message_extension.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/auth_redirect_link.dart';
import 'providers/login_providers.dart';
import 'providers/login_state.dart';
import 'widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);

    return AuthPageLayout(
      header: AuthHeader(
        title: ref.appInfo.name,
        subtitle: ref.welcomeTexts.login.subtitle,
      ),
      errorMessage: loginState.maybeWhen(
        failure: (failure) => failure.toAuthMessage(ref.appConfig),
        orElse: () => null,
      ),
      form: LoginForm(
        onSubmit: (email, password) =>
            ref.read(loginProvider.notifier).signIn(email, password),
        isLoading: loginState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ),
      ),
      switchAuthAction: AuthRedirectLink(
        text: AuthStrings.noAccountText,
        linkText: AuthStrings.registerLink,
        onTap: () => context.push(AppRoutes.register),
      ),
    );
  }
}
