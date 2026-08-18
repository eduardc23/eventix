import '../../domain/entities/event_entity.dart';
import '../enums/event_booking_action_enum.dart';

// Extensión para la lógica de presentación del evento
extension EventEntityUIX on EventEntity {
  EventBookingAction get bookingAction {
    if (!hasSpots) return EventBookingAction.soldOut;
    if (!isBookable) return EventBookingAction.notAvailable;
    if (isFree) return EventBookingAction.bookNow;
    return EventBookingAction.payNow;
  }
}
