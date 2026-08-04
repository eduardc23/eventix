import 'package:eventix/features/events/domain/enums/event_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/events_test_data.dart';

void main() {
  group('EventEntity - Gratuidad', () {
    test('Es gratuito si el precio es cero', () {
      final event = EventsTestData.makeEventEntity(price: 0);
      expect(event.isFree, isTrue);
    });

    test('No es gratuito si el precio es mayor a cero', () {
      final event = EventsTestData.makeEventEntity(price: 1);
      expect(event.isFree, isFalse);
    });
  });

  group('EventEntity - Disponibilidad', () {
    test('Tiene lugares si los cupos disponibles son mayores a cero', () {
      final event = EventsTestData.makeEventEntity(availableSpots: 1);
      expect(event.hasSpots, isTrue);
    });

    test('No tiene lugares si los cupos disponibles son cero', () {
      final event = EventsTestData.makeEventEntity(availableSpots: 0);
      expect(event.hasSpots, isFalse);
    });
  });

  group('EventEntity - Reserva', () {
    test('Es reservable cuando el estado es activo y tiene cupos disponibles', () {
      final event = EventsTestData.makeEventEntity(
        status: EventStatus.active,
        availableSpots: 1,
      );
      expect(event.isBookable, isTrue);
    });

    test('No es reservable cuando el estado es activo pero no tiene cupos', () {
      final event = EventsTestData.makeEventEntity(
        status: EventStatus.active,
        availableSpots: 0,
      );
      expect(event.isBookable, isFalse);
    });

    test('No es reservable si el estado no es activo aunque tenga cupos', () {
      final event = EventsTestData.makeEventEntity(
        status: EventStatus.cancelled,
        availableSpots: 10,
      );
      expect(event.isBookable, isFalse);
    });

    test('No es reservable si no tiene cupos y el estado no es activo', () {
      final event = EventsTestData.makeEventEntity(
        status: EventStatus.cancelled,
        availableSpots: 0,
      );
      expect(event.isBookable, isFalse);
    });
  });

  group('EventEntity - Ocupación', () {
    test('El porcentaje de ocupación es 0.0 cuando la capacidad total es cero', () {
      final event = EventsTestData.makeEventEntity(totalCapacity: 0, availableSpots: 0);
      expect(event.capacityPercentage, equals(0.0));
    });

    test('El porcentaje de ocupación es 0.0 cuando no se ha vendido ningún ticket', () {
      final event = EventsTestData.makeEventEntity(totalCapacity: 100, availableSpots: 100);
      expect(event.capacityPercentage, equals(0.0));
    });

    test('El porcentaje de ocupación es 1.0 cuando el evento está lleno', () {
      final event = EventsTestData.makeEventEntity(totalCapacity: 100, availableSpots: 0);
      expect(event.capacityPercentage, equals(1.0));
    });

    test('El porcentaje de ocupación es 0.5 cuando la mitad de los cupos están ocupados', () {
      final event = EventsTestData.makeEventEntity(totalCapacity: 100, availableSpots: 50);
      expect(event.capacityPercentage, equals(0.5));
    });

    test('Calcula el porcentaje de ocupación correcto con números no divisibles', () {
      final event = EventsTestData.makeEventEntity(totalCapacity: 3, availableSpots: 1);
      expect(event.capacityPercentage, closeTo(0.667, 0.001));
    });
  });
}
