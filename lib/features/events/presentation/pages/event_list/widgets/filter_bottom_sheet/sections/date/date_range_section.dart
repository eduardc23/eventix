import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/filters/event_filter.dart';
import '../../../../../../extensions/date_range_section_ui.dart';

class DateRangeSection extends StatelessWidget {
  const DateRangeSection({
    super.key,
    required this.dateFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.maxDays,
  });

  final DateFilter? dateFilter;
  final ValueChanged<DateFilter> onFilterChanged;
  final VoidCallback onFilterCleared;
  final int maxDays;

  @override
  Widget build(BuildContext context) {
    // El chip solo se marca como seleccionado si el usuario eligió un rango personalizado
    final isCustomRange = dateFilter is DateFilterRange;

    return AppChip.input(
      label: dateFilter.toCustomRangeLabel(),
      avatar: const AppIcon(
        Icons.calendar_today_outlined,
        size: AppIconSize.xs,
      ),
      selected: isCustomRange,
      onSelected: (_) async {
        if (isCustomRange) {
          onFilterCleared();
          return;
        }

        // Si ya había un rango personalizado, lo usamos como valor inicial del picker
        final initialRange = switch (dateFilter) {
          DateFilterRange(:final from, :final to) => DateTimeRange(
            start: from,
            end: to,
          ),
          _ => null,
        };

        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            Duration(days: maxDays),
          ),
          initialDateRange: initialRange,
        );

        if (picked != null) {
          onFilterChanged(DateFilter.range(from: picked.start, to: picked.end));
        }
      },
    );
  }
}
