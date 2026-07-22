import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/filters/event_filter.dart';
import '../../../../../../extensions/date_filter.dart';
import '../../components/filter_chip_group.dart';

class QuickDateSection extends StatelessWidget {
  const QuickDateSection({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final QuickDateOption? selected;
  final ValueChanged<QuickDateOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChipGroup<QuickDateOption>(
      items: QuickDateOption.values,
      itemBuilder: (option) => AppChip.filter(
        label: option.label,
        selected: selected == option,
        onSelected: (_) => onSelected(option),
      ),
    );
  }
}
