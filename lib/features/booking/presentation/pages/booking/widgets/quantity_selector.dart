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
          isSemanticHeader: true,
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
              semanticLabel: BookingStrings.decreaseQuantitySemanticLabel,
              onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            ),
            AppSpacing.md.hGap,
            Semantics(
              label: BookingStrings.quantitySemanticLabel(quantity),
              excludeSemantics: true,
              child: AppText(
                quantity.toString(),
                variant: AppTextVariant.titleLarge,
              ),
            ),
            AppSpacing.md.hGap,
            _QuantityButton(
              icon: Icons.add,
              semanticLabel: BookingStrings.increaseQuantitySemanticLabel,
              onPressed: quantity < maxQuantity
                  ? () => onChanged(quantity + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: AppIcon(icon, onPressed: onPressed),
    );
  }
}
