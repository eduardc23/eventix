import 'package:eventix/features/booking/presentation/pages/booking/providers/booking_checkout_providers.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../events/helpers/events_test_data.dart';

void main() {
  late EventEntity tEvent;

  setUp(() {
    tEvent = EventsTestData.makeEventEntity(availableSpots: 10, price: 50);
  });

  group('BookingQuantity - Estado Inicial', () {
    test('El estado inicial de la cantidad es 1', () {
      final container = createContainer();
      expect(container.read(bookingQuantityProvider(tEvent)), 1);
    });
  });

  group('BookingQuantity - Actualización de Cantidad', () {
    test(
      'Actualiza la cantidad cuando el valor está dentro del rango permitido',
      () {
        final container = createContainer();

        container
            .read(bookingQuantityProvider(tEvent).notifier)
            .updateQuantity(3);

        expect(container.read(bookingQuantityProvider(tEvent)), 3);
      },
    );

    test('Acepta el valor mínimo permitido de 1', () {
      final container = createContainer();

      container
          .read(bookingQuantityProvider(tEvent).notifier)
          .updateQuantity(5);
      container
          .read(bookingQuantityProvider(tEvent).notifier)
          .updateQuantity(1);

      expect(container.read(bookingQuantityProvider(tEvent)), 1);
    });

    test(
      'Acepta el valor máximo permitido basado en los cupos disponibles',
      () {
        final container = createContainer();

        container
            .read(bookingQuantityProvider(tEvent).notifier)
            .updateQuantity(tEvent.availableSpots);

        expect(
          container.read(bookingQuantityProvider(tEvent)),
          tEvent.availableSpots,
        );
      },
    );

    test(
      'Ignora intentos de establecer la cantidad en valores menores que 1',
      () {
        final container = createContainer();

        container
            .read(bookingQuantityProvider(tEvent).notifier)
            .updateQuantity(0);

        expect(container.read(bookingQuantityProvider(tEvent)), 1);
      },
    );

    test('Ignora intentos de establecer la cantidad en valores negativos', () {
      final container = createContainer();

      container
          .read(bookingQuantityProvider(tEvent).notifier)
          .updateQuantity(-5);

      expect(container.read(bookingQuantityProvider(tEvent)), 1);
    });

    test(
      'Ignora valores que exceden la disponibilidad de cupos del evento',
      () {
        final container = createContainer();

        container
            .read(bookingQuantityProvider(tEvent).notifier)
            .updateQuantity(tEvent.availableSpots + 1);

        expect(container.read(bookingQuantityProvider(tEvent)), 1);
      },
    );
  });

  group('BookingQuantity - Independencia y Casos Borde', () {
    test(
      'Solo permite la cantidad de 1 si el evento tiene un único cupo restante',
      () {
        final singleSpotEvent = EventsTestData.makeEventEntity(
          availableSpots: 1,
        );
        final container = createContainer();

        container
            .read(bookingQuantityProvider(singleSpotEvent).notifier)
            .updateQuantity(1);
        expect(container.read(bookingQuantityProvider(singleSpotEvent)), 1);

        container
            .read(bookingQuantityProvider(singleSpotEvent).notifier)
            .updateQuantity(2);
        expect(container.read(bookingQuantityProvider(singleSpotEvent)), 1);
      },
    );
  });

  group('BookingTotalPrice - Cálculo de Precio', () {
    test('El precio inicial corresponde al costo de una única entrada', () {
      final container = createContainer();

      expect(
        container.read(bookingTotalPriceProvider(tEvent)),
        tEvent.price * 1,
      );
    });

    test(
      'Recalcula el total automáticamente cuando se modifica la cantidad',
      () {
        final container = createContainer();

        container
            .read(bookingQuantityProvider(tEvent).notifier)
            .updateQuantity(3);

        expect(
          container.read(bookingTotalPriceProvider(tEvent)),
          tEvent.price * 3,
        );
      },
    );

    test('Calcula el precio total según la cantidad actual', () {
      final container = createContainer();

      container
          .read(bookingQuantityProvider(tEvent).notifier)
          .updateQuantity(5);

      expect(
        container.read(bookingTotalPriceProvider(tEvent)),
        tEvent.price * 5,
      );
    });
  });
}
