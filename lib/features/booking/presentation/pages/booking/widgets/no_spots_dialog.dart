import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/booking_strings.dart';

class NoSpotsDialog extends StatelessWidget {
  const NoSpotsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: AppIcon(
        Icons.event_busy_outlined,
        size: AppIconSize.lg,
        color: context.colorScheme.error,
      ),
      title: const AppText(
        BookingStrings.noSpotsTitle,
        variant: AppTextVariant.headlineSmall,
        textAlign: TextAlign.center,
      ),
      content: const AppText(
        BookingStrings.noSpotsMessage,
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
