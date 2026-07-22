import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.header,
    required this.form,
    required this.switchAuthAction,
    this.errorMessage,
  });

  final Widget header;
  final Widget form;
  final Widget switchAuthAction;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            AppSpacing.xxl.vGap,
            AppFeedbackBanner.error(
              message: errorMessage,
            ),
            form,
            AppSpacing.md.vGap,
            switchAuthAction,
          ],
        ),
      ),
    );
  }
}
