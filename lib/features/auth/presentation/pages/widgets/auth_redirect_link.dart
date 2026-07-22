import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class AuthRedirectLink extends StatelessWidget {
  const AuthRedirectLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text,
          variant: AppTextVariant.bodyMedium,
          color: context.colorScheme.onSurfaceVariant,
        ),
        GestureDetector(
          onTap: onTap,
          child: AppText(
            linkText,
            variant: AppTextVariant.titleSmall,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
