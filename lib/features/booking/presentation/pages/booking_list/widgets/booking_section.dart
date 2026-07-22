import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/booking_entity.dart';
import 'booking_section_header.dart';

class BookingSection extends StatelessWidget {
  const BookingSection({
    super.key,
    required this.title,
    required this.bookings,
    required this.isActive,
    required this.itemBuilder,
  });

  final String title;
  final List<BookingEntity> bookings;
  final bool isActive;
  final Widget Function(BookingEntity) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingSectionHeader(
          label: title,
          count: bookings.length,
          isActive: isActive,
        ),
        ...bookings.map(
          (booking) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xxs,
            ),
            child: itemBuilder(booking),
          ),
        ),
      ],
    );
  }
}
