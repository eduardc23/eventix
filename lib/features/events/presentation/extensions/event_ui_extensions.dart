import '../../domain/entities/event_entity.dart';
import '../constants/events_strings.dart';

enum EventBookingAction { bookNow, payNow, soldOut, notAvailable }

// Extensión para la lógica de presentación del evento
extension EventEntityUIX on EventEntity {
  EventBookingAction get bookingAction {
    if (!hasSpots) return EventBookingAction.soldOut;
    if (!isBookable) return EventBookingAction.notAvailable;
    if (isFree) return EventBookingAction.bookNow;
    return EventBookingAction.payNow;
  }

  String get formattedPrice =>
      isFree ? EventsStrings.free : '\$${price.toString()}';

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get formattedTime =>
      '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

// Extensión para los textos de los botones
extension EventBookingActionX on EventBookingAction {
  String get label => switch (this) {
    EventBookingAction.soldOut => EventsStrings.soldOut,
    EventBookingAction.notAvailable => EventsStrings.notAvailable,
    EventBookingAction.bookNow => EventsStrings.bookNow,
    EventBookingAction.payNow => EventsStrings.payNow,
  };
}
