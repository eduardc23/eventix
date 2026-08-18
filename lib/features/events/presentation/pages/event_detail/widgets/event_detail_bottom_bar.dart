import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/events_strings.dart';
import '../../../constants/events_test_keys.dart';
import '../../../enums/event_booking_action_enum.dart';

class EventDetailBottomBar extends StatelessWidget {
  final String priceLabel;
  final String semanticPrice;
  final EventBookingAction action;
  final VoidCallback? onPressed;

  const EventDetailBottomBar({
    super.key,
    required this.priceLabel,
    required this.semanticPrice,
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: AppElevation.lg,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.md.all,
          child: Row(
            children: [
              Semantics(
                label: EventsStrings.totalPriceSemanticLabel(semanticPrice),
                excludeSemantics: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      EventsStrings.totalPrice,
                      variant: AppTextVariant.bodySmall,
                    ),
                    AppText(priceLabel, variant: AppTextVariant.titleLarge),
                  ],
                ),
              ),
              AppSpacing.xl.hGap,
              Expanded(
                child: AppButton.primary(
                  key: EventsTestKeys.eventDetailBookingActionButton,
                  label: action.label,
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
