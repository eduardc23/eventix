import 'package:flutter_test/flutter_test.dart';

import '../../helpers/booking_test_data.dart';

void main() {
  group('BookingEntity - Temporalidad', () {
    test('Es una reserva pasada si la fecha del evento es anterior a la actual', () {
      final booking = BookingTestData.makeBookingEntity(
        eventDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(booking.isPast, isTrue);
    });

    test('No es una reserva pasada si la fecha del evento es posterior a la actual', () {
      final booking = BookingTestData.makeBookingEntity(
        eventDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(booking.isPast, isFalse);
    });

    test('Es una reserva futura si la fecha del evento es posterior a la actual', () {
      final booking = BookingTestData.makeBookingEntity(
        eventDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(booking.isFuture, isTrue);
    });

    test('No es una reserva futura si la fecha del evento es anterior a la actual', () {
      final booking = BookingTestData.makeBookingEntity(
        eventDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(booking.isFuture, isFalse);
    });

    test('La propiedad isFuture es siempre el inverso de isPast', () {
      final booking = BookingTestData.makeBookingEntity(
        eventDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(booking.isFuture, equals(!booking.isPast));
    });
  });
}
