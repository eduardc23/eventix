import 'package:eventix/features/booking/data/models/booking_model.dart';
import 'package:eventix/features/booking/domain/entities/booking_entity.dart';
import 'package:eventix/features/booking/domain/entities/create_booking_params.dart';

class BookingTestData {
  static final tDate = DateTime(2026, 10, 31);
  static final tCreatedAt = DateTime(2026, 7, 30);

  static final tBookingModel = BookingModel(
    uid: '123',
    userId: 'userA',
    eventId: 'eventX',
    eventTitle: 'Concierto',
    eventImageUrl: 'https://img.com',
    eventDate: tDate,
    tickets: 2,
    totalPrice: 150.0,
    createdAt: tCreatedAt,
  );

  static final tBookingEntity = BookingEntity(
    uid: '123',
    userId: 'userA',
    eventId: 'eventX',
    eventTitle: 'Concierto',
    eventImageUrl: 'https://img.com',
    eventDate: tDate,
    tickets: 2,
    totalPrice: 150.0,
    createdAt: tCreatedAt,
  );

  static final tCreateBookingParams = CreateBookingParams(
    userId: 'userA',
    eventId: 'eventX',
    eventTitle: 'Concierto',
    eventImageUrl: 'https://img.com',
    eventDate: tDate,
    tickets: 2,
    totalPrice: 150.0,
  );

  static BookingEntity makeBookingEntity({
    String? uid,
    DateTime? eventDate,
    String? userId,
    String? eventTitle,
  }) {
    return BookingEntity(
      uid: uid ?? '123',
      userId: userId ?? 'userA',
      eventId: 'eventX',
      eventTitle: eventTitle ?? 'Concierto',
      eventImageUrl: 'https://img.com',
      eventDate: eventDate ?? tDate,
      tickets: 2,
      totalPrice: 150.0,
      createdAt: tCreatedAt,
    );
  }
}
