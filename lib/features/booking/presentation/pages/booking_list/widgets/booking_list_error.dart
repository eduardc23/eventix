import 'package:app_ui_kit/app_ui_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/booking_strings.dart';
import '../providers/booking_list_provider.dart';

class BookingListError extends ConsumerWidget {
  const BookingListError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppEmptyState(
      icon: Icons.wifi_off_outlined,
      title: BookingStrings.errorTitle,
      description: error,
      actionLabel: BookingStrings.retryAction,
      onAction: () {
        ref.invalidate(bookingListProvider);
      },
    );
  }
}
