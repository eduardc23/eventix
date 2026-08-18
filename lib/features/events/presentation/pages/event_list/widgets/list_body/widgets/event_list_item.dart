import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/presentation/extensions/date_time_extensions.dart';
import 'package:eventix/core/presentation/extensions/price_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../../core/router/app_routes.dart';
import '../../../../../../domain/entities/event_entity.dart';
import '../../../../../constants/events_test_keys.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    return EventCard(
      key: EventsTestKeys.eventListItem(event.uid),
      data: EventCardData(
        imageUrl: event.imageUrl,
        name: event.title,
        venueName: event.cityName,
        dateLabel: event.date.toEventDate(),
        dateSemanticLabel: event.date.toEventDateSemantic(),
        priceLabel: event.price.toFormattedPrice(),
        priceSemanticLabel: event.price.toSemanticPrice(),
      ),
      onTap: () => context.push(AppRoutes.eventDetail, extra: event),
    );
  }
}
