import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../../core/router/app_routes.dart';
import '../../../../../../domain/entities/event_entity.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    return EventCard(
      data: EventCardData(
        imageUrl: event.imageUrl,
        name: event.title,
        venueName: event.cityName,
        date: event.date,
        price: event.price.toInt().toString(),
        isFree: event.isFree,
      ),
      onTap: () => context.push(AppRoutes.eventDetail, extra: event),
    );
  }
}
