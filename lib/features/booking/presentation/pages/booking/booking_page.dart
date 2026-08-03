import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/providers/booking_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/domain/failures/app_failure.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../events/domain/entities/event_entity.dart';
import '../../../../events/presentation/pages/event_list/providers/list/events_notifier.dart';
import '../../../domain/failures/booking_failures.dart';
import '../../constants/booking_strings.dart';
import '../../constants/booking_test_keys.dart';
import '../../extensions/booking_failure_message.dart';
import 'providers/booking_checkout_providers.dart';
import 'providers/create_booking_provider.dart';
import 'providers/create_booking_state.dart';
import 'widgets/booking_success_dialog.dart';
import 'widgets/no_spots_dialog.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/quantity_selector.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key, required this.event});

  final EventEntity event;

  void _onBookingSuccess(BuildContext context, WidgetRef ref, int totalPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookingSuccessDialog(
        isFree: event.isFree,
        eventTitle: event.title,
        totalPrice: totalPrice,
        onOkPressed: () async {
          ref.invalidate(eventsProvider);
          ref.invalidate(bookingListProvider);
          context.pop();
          final router = GoRouter.of(context);
          await Future.delayed(AppDurations.medium);
          router.go(AppRoutes.bookings);
        },
      ),
    );
  }

  void _onBookingFailure(BuildContext context, AppFailure failure) {
    if (failure is NoSpotsAvailableFailure) {
      showDialog(context: context, builder: (_) => const NoSpotsDialog());
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          failure.toBookingMessage,
          variant: AppTextVariant.labelMedium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(bookingQuantityProvider(event));
    final totalPrice = ref.watch(bookingTotalPriceProvider(event));
    final bookingState = ref.watch(createBookingProvider);

    ref.listen<CreateBookingState>(createBookingProvider, (_, next) {
      next.whenOrNull(
        success: () => _onBookingSuccess(context, ref, totalPrice),
        failure: (failure) => _onBookingFailure(context, failure),
      );
    });

    return AppScaffold(
      appBar: AppBar(
        title: AppText(
          event.isFree
              ? BookingStrings.bookingConfirmTitle
              : BookingStrings.checkoutTitle,
          variant: AppTextVariant.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.md.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummaryCard(
              imageUrl: event.imageUrl,
              title: event.title,
              isFree: event.isFree,
              totalPrice: totalPrice,
              quantity: quantity,
            ),
            AppSpacing.xxl.vGap,
            QuantitySelector(
              quantity: quantity,
              maxQuantity: event.availableSpots,
              onChanged: (value) => ref
                  .read(bookingQuantityProvider(event).notifier)
                  .updateQuantity(value),
            ),
            AppSpacing.xxl.vGap,
            if (!event.isFree) ...[
              const PaymentMethodCard(),
              AppSpacing.xxl.vGap,
            ],
            AppButton.primary(
              key: BookingTestKeys.confirmActionButton,
              label: event.isFree
                  ? BookingStrings.confirmBooking
                  : BookingStrings.payNow,
              expanded: true,
              onPressed: bookingState.isLoading
                  ? null
                  : () {
                      final notifier = ref.read(createBookingProvider.notifier);
                      notifier.createBooking(event);
                    },
              isLoading: bookingState.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
