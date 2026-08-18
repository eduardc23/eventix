import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config_extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/presentation/extensions/async_value_extensions.dart';
import '../../../constants/booking_strings.dart';
import '../../../extensions/booking_failure_message.dart';
import '../../../extensions/booking_ui_extensions.dart';
import '../../../extensions/date_time_extensions.dart';
import '../providers/booking_list_provider.dart';
import 'booking_list_empty_state.dart';
import 'booking_list_error.dart';
import 'booking_section.dart';

class BookingListBody extends ConsumerWidget {
  const BookingListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingListProvider);

    return bookingsAsync.when(
      loading: () => const Center(
        child: AppLoader.medium(semanticsLabel: BookingStrings.loadingBookings),
      ),
      error: (error, stack) => BookingListError(
        error: error.asFailure.toBookingMessage(ref.appConfig),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return const BookingListEmptyState();
        }

        final upcoming = ref.watch(upcomingBookingsProvider);
        final past = ref.watch(pastBookingsProvider);

        return Semantics(
          label: BookingStrings.bookingListSemanticLabel,
          container: true,
          child: RefreshIndicator(
            onRefresh: () => ref.read(bookingListProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingSection(
                    title: BookingStrings.upcomingSection,
                    bookings: upcoming,
                    isActive: true,
                    itemBuilder: (booking) => BookingCard(
                      data: booking.toCardData,
                      timeLabel: booking.eventDate.bookingTimeLabel,
                    ),
                  ),
                  BookingSection(
                    title: BookingStrings.pastSection,
                    bookings: past,
                    isActive: false,
                    itemBuilder: (booking) =>
                        PastBookingCard(data: booking.toCardData),
                  ),
                  AppSpacing.xxl.vGap,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
