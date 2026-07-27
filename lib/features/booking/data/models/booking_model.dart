import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/booking_firestore_constants.dart';

class BookingModel {
  final String? uid;
  final String userId;
  final String eventId;
  final String eventTitle;
  final String eventImageUrl;
  final DateTime eventDate;
  final int tickets;
  final double totalPrice;
  final DateTime createdAt;

  const BookingModel({
    this.uid,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.eventImageUrl,
    required this.eventDate,
    required this.tickets,
    required this.totalPrice,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      uid: json[BookingFirestoreConstants.uidField] as String?,
      userId: json[BookingFirestoreConstants.userIdField] as String,
      eventId: json[BookingFirestoreConstants.eventIdField] as String,
      eventTitle: json[BookingFirestoreConstants.eventTitleField] as String,
      eventImageUrl:
          json[BookingFirestoreConstants.eventImageUrlField] as String,
      eventDate: (json[BookingFirestoreConstants.eventDateField] as Timestamp)
          .toDate(),
      tickets: json[BookingFirestoreConstants.ticketsField] as int,
      totalPrice: (json[BookingFirestoreConstants.totalPriceField] as num)
          .toDouble(),
      createdAt: (json[BookingFirestoreConstants.createdAtField] as Timestamp)
          .toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (uid != null) BookingFirestoreConstants.uidField: uid,
      BookingFirestoreConstants.userIdField: userId,
      BookingFirestoreConstants.eventIdField: eventId,
      BookingFirestoreConstants.eventTitleField: eventTitle,
      BookingFirestoreConstants.eventImageUrlField: eventImageUrl,
      BookingFirestoreConstants.eventDateField: Timestamp.fromDate(eventDate),
      BookingFirestoreConstants.ticketsField: tickets,
      BookingFirestoreConstants.totalPriceField: totalPrice,
      BookingFirestoreConstants.createdAtField: Timestamp.fromDate(createdAt),
    };
  }
}
