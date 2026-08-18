import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/config/app_config_extensions.dart';
import '../../../../../constants/events_strings.dart';
import '../../../providers/filters/event_filters_providers.dart';

class SheetHeader extends ConsumerWidget {
  const SheetHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AppText(
            ref.sectionsConfig.filters,
            variant: AppTextVariant.titleMedium,
            isSemanticHeader: true,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AppTextButton(
            label: EventsStrings.resetFilters,
            variant: AppTextVariant.labelMedium,
            onPressed: () =>
                ref.read(draftEventFiltersProvider.notifier).reset(),
          ),
        ),
      ],
    );
  }
}
