import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: AppSpacing.sm.all,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(
              icon,
              size: AppIconSize.md,
              color: context.colorScheme.primary,
            ),
            AppSpacing.xs.hGap,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    variant: AppTextVariant.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.xxxs.vGap,
                  AppText(subtitle, variant: AppTextVariant.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
