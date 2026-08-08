import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';


class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.subtitle,
    required this.title,
  });

  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          title ,
          variant: AppTextVariant.displayMedium,
          color: context.colorScheme.primary,
        ),
        AppSpacing.xs.vGap,
        AppText(
          subtitle,
          variant: AppTextVariant.bodyLarge,
          color: context.colorScheme.onSurface,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
