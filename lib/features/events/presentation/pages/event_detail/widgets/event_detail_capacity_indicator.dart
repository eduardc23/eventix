import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/events_strings.dart';

class EventDetailCapacityIndicator extends StatelessWidget {
  final double capacityPercentage;
  final int availableSpots;

  const EventDetailCapacityIndicator({
    super.key,
    required this.capacityPercentage,
    required this.availableSpots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              EventsStrings.availability,
              variant: AppTextVariant.titleMedium,
            ),
            AppText(
              EventsStrings.remainingSpots(availableSpots),
              variant: AppTextVariant.bodyMedium,
              color: context.colorScheme.primary,
            ),
          ],
        ),
        AppSpacing.xs.vGap,
        LinearProgressIndicator(
          value: capacityPercentage.clamp(0.0, 1.0),
          borderRadius: BorderRadius.circular(AppRadius.md),
          minHeight: AppSpacing.xs,
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          color: context.colorScheme.primary,
        ),
      ],
    );
  }
}
