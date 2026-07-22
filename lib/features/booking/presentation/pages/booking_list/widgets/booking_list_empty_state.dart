import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../constants/booking_strings.dart';

class BookingListEmptyState extends StatelessWidget {
  const BookingListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.confirmation_number_outlined,
      title: BookingStrings.emptyStateTitle,
      description: BookingStrings.emptyStateMessage,
    );
  }
}
