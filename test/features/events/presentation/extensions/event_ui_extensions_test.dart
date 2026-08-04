import 'package:eventix/features/events/domain/enums/event_status_enum.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
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

  group('EventEntityUIX - Formato de Precio', () {
    test('Texto de "gratis" cuando el precio es 0', () {
      final event = EventsTestData.makeEventEntity(price: 0);
      expect(event.formattedPrice, EventsStrings.free);
    });

    test('Precio formateado con el símbolo \$ cuando tiene costo', () {
      final event = EventsTestData.makeEventEntity(price: 250);
      expect(event.formattedPrice, '\$250');
    });
  });

  group('EventEntityUIX - Formato de Fecha', () {
    test('Fecha formateada correctamente como día/mes/año (d/m/yyyy)', () {
      final event = EventsTestData.makeEventEntity(
        date: DateTime(2026, 5, 14),
      ); // 14 de mayo de 2026
      expect(event.formattedDate, '14/5/2026');
    });
  });

  group('EventEntityUIX - Formato de Hora', () {
    test('Hora formateada asegurando 2 dígitos en los minutos', () {
      // Hora: 14:05 (El 5 debe tener un 0 a la izquierda)
      final event = EventsTestData.makeEventEntity(date: DateTime(2026, 12, 1, 14, 5));
      expect(event.formattedTime, '14:05');
    });

    test('Hora formateada correctamente con minutos terminados en 0', () {
      // Hora: 9:30
      final event = EventsTestData.makeEventEntity(date: DateTime(2026, 12, 1, 9, 30));
      expect(event.formattedTime, '9:30');
    });
  });
}
