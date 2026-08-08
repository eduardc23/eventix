import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/config/app_config_extensions.dart';

class BookingListEmptyState extends ConsumerWidget {
  const BookingListEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppEmptyState(
      icon: Icons.confirmation_number_outlined,
      title: ref.emptyMessages.bookings.title,
      description: ref.emptyMessages.bookings.description,
    );
  }
}
