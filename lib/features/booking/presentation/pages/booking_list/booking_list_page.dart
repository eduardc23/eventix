import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../constants/booking_strings.dart';
import 'widgets/booking_list_body.dart';

class BookingListPage extends StatelessWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
        title: BookingStrings.bookingListTitle,
      ),
      body: const BookingListBody(),
    );
  }
}
