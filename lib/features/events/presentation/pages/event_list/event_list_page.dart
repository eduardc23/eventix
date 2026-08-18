import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/app_config_extensions.dart';
import '../../../../../core/presentation/widgets/drawer_menu_icon.dart';
import '../../constants/events_strings.dart';
import 'widgets/event_active_filters_bar.dart';
import 'widgets/filter_bottom_sheet/event_filter_bottom_sheet.dart';
import 'widgets/list_body/event_list_body.dart';

class EventListPage extends ConsumerWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppTopBar(
        leading: const DrawerMenuIcon(),
        title: ref.sectionsConfig.events,
        actions: [
          AppIcon(
            Icons.tune_outlined,
            onPressed: () => EventFilterBottomSheet.show(context),
            semanticLabel: EventsStrings.filterIconSemanticLabel,
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