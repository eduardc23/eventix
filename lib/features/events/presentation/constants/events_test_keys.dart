import 'package:flutter/widgets.dart';

class EventsTestKeys {
  EventsTestKeys._();

  static ValueKey<String> eventListItem(String eventId) =>
      ValueKey<String>('events.list.item.$eventId');

  static const Key eventDetailBookingActionButton = Key(
    'events.detail.bookingActionButton',
  );
}
