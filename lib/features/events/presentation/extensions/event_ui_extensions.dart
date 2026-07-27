import '../../domain/entities/event_entity.dart';
import '../constants/events_strings.dart';
import '../enums/event_booking_action_enum.dart';

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
