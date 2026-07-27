import '../constants/events_strings.dart';

enum EventBookingAction { bookNow, payNow, soldOut, notAvailable }

extension EventBookingActionX on EventBookingAction {
  String get label => switch (this) {
    EventBookingAction.soldOut => EventsStrings.soldOut,
    EventBookingAction.notAvailable => EventsStrings.notAvailable,
    EventBookingAction.bookNow => EventsStrings.bookNow,
    EventBookingAction.payNow => EventsStrings.payNow,
  };
}
