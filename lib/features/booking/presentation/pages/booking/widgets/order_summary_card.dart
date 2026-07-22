import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../constants/booking_strings.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isFree,
    required this.totalPrice,
    required this.quantity,
  });

  final String imageUrl;
  final String title;
  final bool isFree;
  final int totalPrice;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppElevation.none,
      color: context.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            BookingStrings.orderSummaryTitle,
            variant: AppTextVariant.titleMedium,
          ),
          AppSpacing.sm.vGap,
          const Divider(),
          AppSpacing.sm.vGap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: AppImage.network(
                  imageUrl,
                  width: 64,
                  height: 64,
                ),
              ),
              AppSpacing.md.hGap,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      variant: AppTextVariant.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.xxxs.vGap,
                    AppText(
                      BookingStrings.quantityLabel(quantity),
                      variant: AppTextVariant.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.md.vGap,
          const Divider(),
          AppSpacing.md.vGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                BookingStrings.totalToPay,
                variant: AppTextVariant.titleMedium,
              ),
              AppText(
                isFree ? BookingStrings.freeLabel : '\$$totalPrice',
                variant: AppTextVariant.titleLarge,
                color: context.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
