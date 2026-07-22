import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/events_strings.dart';
import '../../../extensions/date_filter.dart';
import '../providers/filters/event_filters_providers.dart';

class EventActiveFiltersBar extends ConsumerWidget {
  const EventActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(appliedEventFiltersProvider);

    final activeFilters = [
      if (filters.category != null)
        (
          label: filters.category!.name,
          icon: Icons.category,
          onClear: () {
            ref.read(appliedEventFiltersProvider.notifier).clearCategory();
          },
        ),
      if (filters.city != null)
        (
          label: filters.city!.name,
          icon: Icons.location_on_outlined,
          onClear: () {
            ref.read(appliedEventFiltersProvider.notifier).clearCity();
          },
        ),
      if (filters.date != null)
        (
          label: filters.date!.toDisplayString(),
          icon: Icons.calendar_today_outlined,
          onClear: () {
            ref.read(appliedEventFiltersProvider.notifier).clearDate();
          },
        ),
    ];

    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: Wrap(
        spacing: AppSpacing.xxs,
        runSpacing: AppSpacing.xxxs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...activeFilters.map(
            (f) => AppChip.input(
              label: f.label,
              avatar: AppIcon(
                f.icon,
                size: AppIconSize.xs,
                color: context.colorScheme.surface,
              ),
              selected: true,
              onSelected: (_) => f.onClear(),
            ),
          ),
          AppTextButton(
            onPressed: () {
              ref.read(appliedEventFiltersProvider.notifier).clearAll();
            },
            label: EventsStrings.clearFilters,
            variant: AppTextVariant.labelMedium,
          ),
        ],
      ),
    );
  }
}
