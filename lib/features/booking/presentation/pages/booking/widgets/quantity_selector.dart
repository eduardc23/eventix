import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../constants/booking_strings.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    required this.maxQuantity,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int maxQuantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          BookingStrings.quantityTitle,
          variant: AppTextVariant.titleMedium,
        ),
        AppSpacing.xs.vGap,
        const AppText(
          BookingStrings.selectQuantity,
          variant: AppTextVariant.bodySmall,
        ),
        AppSpacing.sm.vGap,
        Row(
          children: [
            _QuantityButton(
              icon: Icons.remove,
              onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            ),
            AppSpacing.md.hGap,
            AppText(
              quantity.toString(),
              variant: AppTextVariant.titleLarge,
            ),
            AppSpacing.md.hGap,
            _QuantityButton(
              icon: Icons.add,
              onPressed:
                  quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
