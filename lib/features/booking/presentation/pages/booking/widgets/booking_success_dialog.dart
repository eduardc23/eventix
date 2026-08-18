import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/booking_strings.dart';
import '../../../constants/booking_test_keys.dart';

class BookingSuccessDialog extends ConsumerWidget {
  const BookingSuccessDialog({
    super.key,
    required this.isFree,
    required this.eventTitle,
    required this.totalPrice,
    required this.onOkPressed,
  });

  final bool isFree;
  final String eventTitle;
  final int totalPrice;
  final VoidCallback onOkPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: AppIcon(
        Icons.check_circle_outline,
        size: AppIconSize.lg,
        color: context.colorScheme.primary,
      ),
      title: AppText(
        ref.appConfig.alerts.bookingSuccess.title,
        variant: AppTextVariant.headlineSmall,
        textAlign: TextAlign.center,
        isSemanticHeader: true,
      ),
      content: AppText(
        isFree
            ? ref.appConfig.alerts.bookingSuccess.message
            : ref.appConfig.alerts.paymentProcessed,
        variant: AppTextVariant.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        AppButton.primary(
          key: BookingTestKeys.successDialogOkButton,
          label: BookingStrings.ok,
          expanded: true,
          onPressed: onOkPressed,
        ),
      ],
    );
  }
}
