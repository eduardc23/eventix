import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/events_strings.dart';
import '../../../providers/filters/categories_notifier.dart';
import '../components/async_filter_section.dart';
import '../components/filter_chip_group.dart';

class CategoryFilterSection extends ConsumerWidget {
  const CategoryFilterSection({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final String? selectedCategoryId;
  final void Function(String id, String name) onCategorySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesProvider);

    return AsyncFilterSection(
      state: state,
      icon: Icons.category_outlined,
      errorTitle: EventsStrings.categoriesLoadError,
      onRetry: () => ref.read(categoriesProvider.notifier).reload(),
      builder: (categories) => FilterChipGroup(
        items: categories,
        itemBuilder: (category) => AppChip.filter(
          label: category.name,
          selected: selectedCategoryId == category.uid,
          onSelected: (_) => onCategorySelected(category.uid, category.name),
        ),
      ),
    );
  }
}
