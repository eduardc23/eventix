import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../constants/events_strings.dart';
import 'widgets/event_active_filters_bar.dart';
import 'widgets/filter_bottom_sheet/event_filter_bottom_sheet.dart';
import 'widgets/list_body/event_list_body.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        onMenuPressed: ()=> Scaffold.of(context).openDrawer(),
        title: EventsStrings.eventsTitle,
        actions: [
          AppIcon(
            Icons.tune_outlined,
            onPressed: () => EventFilterBottomSheet.show(context),
          ),
        ],
      ),

      body: const Column(
        children: [
          EventActiveFiltersBar(),
          Expanded(child: EventListBody()),
        ],
      ),
    );
  }
}
