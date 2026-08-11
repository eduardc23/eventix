import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../../domain/failures/config_failures.dart';
import '../extensions/config_failure_message_extension.dart';

class ConfigErrorPage extends StatelessWidget {
  final ConfigFailure failure;

  const ConfigErrorPage({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.xl.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon(
                Icons.warning_amber_rounded,
                size: AppIconSize.lg,
                color: colorScheme.error,
              ),
              AppSpacing.lg.vGap,
              const AppText(
                AppConstants.configError,
                variant: AppTextVariant.headlineSmall,
              ),
              AppSpacing.xs.vGap,
              AppText(
                failure.toErrorMessage,
                variant: AppTextVariant.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
