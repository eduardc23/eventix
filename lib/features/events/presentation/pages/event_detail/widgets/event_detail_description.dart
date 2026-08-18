import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/events_strings.dart';

class EventDetailDescription extends StatelessWidget {
  const EventDetailDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          EventsStrings.aboutEvent,
          variant: AppTextVariant.headlineSmall,
          isSemanticHeader: true,
        ),
        AppSpacing.sm.vGap,
        AppText(description, variant: AppTextVariant.bodyLarge),
      ],
    );
  }
}
