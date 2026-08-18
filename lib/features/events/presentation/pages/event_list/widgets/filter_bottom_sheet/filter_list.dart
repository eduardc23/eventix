import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/config/app_config_extensions.dart';
import '../../../../constants/events_strings.dart';
import '../../providers/filters/event_filters_providers.dart';
import 'sections/category_filter_section.dart';
import 'sections/city_filter_section.dart';
import 'sections/date/date_filter_section.dart';

class FilterList extends ConsumerWidget {
  const FilterList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftEventFiltersProvider);
    final notifier = ref.read(draftEventFiltersProvider.notifier);

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterGroup(
            title: EventsStrings.filterCategory,
            child: CategoryFilterSection(
              selectedCategoryId: draft.category?.id,
              onCategorySelected: notifier.toggleCategory,
            ),
          ),
          _FilterGroup(
            title: EventsStrings.filterCity,
            child: CityFilterSection(
              selectedCityId: draft.city?.id,
              onCitySelected: notifier.toggleCity,
            ),
          ),
          _FilterGroup(
            title: EventsStrings.filterDate,
            child: DateFilterSection(
              selectedDate: draft.date,
              onQuickOptionSelected: notifier.toggleQuickDate,
              onRangeSelected: notifier.selectDateRange,
              onRangeCleared: notifier.clearDateRange,
              dateRangeMaxDays: ref.uiConfig.dateRangeMaxDays,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          variant: AppTextVariant.labelLarge,
          isSemanticHeader: true,
        ),
        AppSpacing.xs.vGap,
        child,
        AppSpacing.lg.vGap,
      ],
    );
  }
}
