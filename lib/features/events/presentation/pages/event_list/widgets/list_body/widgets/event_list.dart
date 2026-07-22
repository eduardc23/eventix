import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/entities/event_entity.dart';
import 'event_list_item.dart';

class EventList extends StatelessWidget {
  const EventList({super.key, required this.events});

  final List<EventEntity> events;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.md.all,
      itemCount: events.length,
      separatorBuilder: (_, _) => AppSpacing.sm.vGap,
      itemBuilder: (_, index) => EventListItem(event: events[index]),
    );
  }
}
