import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/booking_strings.dart';

class BookingSuccessDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: AppIcon(
        Icons.check_circle_outline,
        size: AppIconSize.lg,
        color: context.colorScheme.primary,
      ),
      title: const AppText(
        BookingStrings.bookingConfirmedTitle,
        variant: AppTextVariant.headlineSmall,
        textAlign: TextAlign.center,
      ),
      content: AppText(
        isFree
            ? BookingStrings.bookingConfirmedMessage(eventTitle)
            : BookingStrings.paymentProcessedMessage(totalPrice),
        variant: AppTextVariant.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        AppButton.primary(
          label: BookingStrings.ok,
          expanded: true,
          onPressed: onOkPressed,
        ),
      ],
    );
  }
}
