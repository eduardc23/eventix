import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../constants/booking_strings.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          BookingStrings.paymentMethodTitle,
          variant: AppTextVariant.titleMedium,
        ),
        AppSpacing.sm.vGap,
        Semantics(
          label: BookingStrings.paymentMethodSemanticLabel,
          button: false,
          excludeSemantics: true,
          child: AppCard(
            elevation: AppElevation.none,
            color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: ListTile(
              leading: AppIcon(
                Icons.credit_card,
                color: context.colorScheme.primary,
              ),
              title: const AppText(
                BookingStrings.mockCreditCard,
                variant: AppTextVariant.labelLarge,
              ),
              subtitle: const AppText(
                BookingStrings.mockCardNumber,
                variant: AppTextVariant.bodySmall,
              ),
              trailing: AppIcon(
                Icons.check_circle,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
