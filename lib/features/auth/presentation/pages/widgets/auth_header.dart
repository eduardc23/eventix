import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          AppStrings.appName,
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
