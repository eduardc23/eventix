import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/app_config_extensions.dart';
import '../../../../../core/presentation/widgets/drawer_menu_icon.dart';
import 'widgets/booking_list_body.dart';

class BookingListPage extends ConsumerWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppTopBar(
        leading: DrawerMenuIcon(),
        title: ref.sectionsConfig.myBookings,
      ),
      body: const BookingListBody(),
    );
  }
}
