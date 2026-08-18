import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/config/app_config_extensions.dart';
import '../../../constants/booking_strings.dart';

class NoSpotsDialog extends ConsumerWidget {
  const NoSpotsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.alertsConfig.noSpots;

    return AlertDialog(
      icon: AppIcon(
        Icons.event_busy_outlined,
        size: AppIconSize.lg,
        color: context.colorScheme.error,
      ),
      title: AppText(
        config.title,
        variant: AppTextVariant.headlineSmall,
        textAlign: TextAlign.center,
        isSemanticHeader: true,
      ),
      content: AppText(
        config.message,
        variant: AppTextVariant.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        AppButton.primary(
          label: BookingStrings.ok,
          expanded: true,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
