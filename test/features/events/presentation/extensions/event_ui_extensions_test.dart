import 'package:eventix/features/events/domain/enums/event_status_enum.dart';
import 'package:eventix/features/events/presentation/enums/event_booking_action_enum.dart';
import 'package:eventix/features/events/presentation/extensions/event_ui_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/events_test_data.dart';

void main() {
  group('EventEntityUIX - Acción de Reserva', () {
    test('Retorno de soldOut cuando no hay cupos disponibles', () {
      final event = EventsTestData.makeEventEntity(availableSpots: 0);
      expect(event.bookingAction, EventBookingAction.soldOut);
    });

    test('Retorno de bookNow cuando el evento es gratis y tiene cupos', () {
      final event = EventsTestData.makeEventEntity(
        availableSpots: 10,
        price: 0,
        status: EventStatus.active,
      );
      expect(event.bookingAction, EventBookingAction.bookNow);
    });

    test('Retorno de payNow cuando el evento tiene costo y tiene cupos', () {
      final event = EventsTestData.makeEventEntity(
        availableSpots: 10,
        price: 150,
        status: EventStatus.active,
      );
      expect(event.bookingAction, EventBookingAction.payNow);
    });
  });
}
