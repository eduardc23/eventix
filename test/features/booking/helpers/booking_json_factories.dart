import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/booking/data/constants/booking_firestore_constants.dart';

/// Fábrica de mapas JSON para pruebas del feature de reservas (booking).
class BookingJsonFactories {
  
  /// Crea un mapa compatible con `BookingModel.fromJson`.
  static Map<String, dynamic> createBookingJson({
    String? uid,
    String? userId,
    String? eventId,
    String? eventTitle,
    String? eventImageUrl,
    DateTime? eventDate,
    int? tickets,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime(2026, 10, 31);
    return {
      BookingFirestoreConstants.uidField: uid ?? '123',
      BookingFirestoreConstants.userIdField: userId ?? 'userA',
      BookingFirestoreConstants.eventIdField: eventId ?? 'eventX',
      BookingFirestoreConstants.eventTitleField: eventTitle ?? 'Concierto',
      BookingFirestoreConstants.eventImageUrlField: eventImageUrl ?? 'https://img.com',
      BookingFirestoreConstants.eventDateField: Timestamp.fromDate(eventDate ?? now),
      BookingFirestoreConstants.ticketsField: tickets ?? 2,
      BookingFirestoreConstants.totalPriceField: totalPrice ?? 150.0,
      BookingFirestoreConstants.createdAtField: Timestamp.fromDate(createdAt ?? now),
      BookingFirestoreConstants.updatedAtField: Timestamp.fromDate(updatedAt ?? now),
    };
  }
}
