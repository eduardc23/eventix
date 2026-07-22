import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class BookingSectionHeader extends StatelessWidget {
  const BookingSectionHeader({
    required this.label,
    required this.count,
    required this.isActive,
    super.key,
  });

  /// Título de la sección.
  final String label;

  /// Cantidad de elementos en esta sección.
  final int count;

  /// Indica si la sección está activa (ej: reservas próximas).
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xxs,
            height: AppSpacing.lg,
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primary : colorScheme.outline,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          AppSpacing.sm.hGap,

          AppText(label, variant: AppTextVariant.titleMedium),
          AppSpacing.xs.hGap,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxxs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: AppText('$count', variant: AppTextVariant.labelSmall),
          ),
        ],
      ),
    );
  }
}
