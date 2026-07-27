import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/enums/quick_date_option_enum.dart';
import '../../../../../../../domain/filters/event_filter.dart';
import 'date_range_section.dart';
import 'quick_date_section.dart';

/// Sección de filtro de fecha.
///
/// Recibe el estado tipado [DateFilter] y delega los callbacks al notifier.
/// No tiene estado propio — es completamente controlada desde afuera.
///
/// Separar [QuickDateSection] y [DateRangeSection] en este widget
/// evita duplicar la lógica de "¿cuál opción está activa?" en ambos hijos.
class DateFilterSection extends StatelessWidget {
  const DateFilterSection({
    super.key,
    required this.selectedDate,
    required this.onQuickOptionSelected,
    required this.onRangeSelected,
    required this.onRangeCleared,
  });

  final DateFilter? selectedDate;
  final ValueChanged<QuickDateOption> onQuickOptionSelected;
  final void Function(DateTime from, DateTime to) onRangeSelected;
  final VoidCallback onRangeCleared;

  /// La quick option activa, si la hay.
  QuickDateOption? get _activeQuickOption => switch (selectedDate) {
    DateFilterQuick(:final option) => option,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuickDateSection(
          selected: _activeQuickOption,
          onSelected: onQuickOptionSelected,
        ),
        AppSpacing.xs.vGap,
        DateRangeSection(
          dateFilter: selectedDate,
          onFilterChanged: (newFilter) {
            if (newFilter is DateFilterRange) {
              onRangeSelected(newFilter.from, newFilter.to);
            }
          },
          onFilterCleared: onRangeCleared,
        ),
      ],
    );
  }
}
