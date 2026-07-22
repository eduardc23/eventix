import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class FilterChipGroup<T> extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  final List<T> items;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items.map(itemBuilder).toList(),
    );
  }
}
