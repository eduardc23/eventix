import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader({
    super.key,
    required this.categoryName,
    required this.title,
  });

  final String categoryName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppChip.filter(
          label: categoryName,
          selected: false,
          onSelected: (_) {},
        ),
        AppSpacing.xs.vGap,
        AppText(title, variant: AppTextVariant.headlineMedium),
      ],
    );
  }
}
