import 'package:eventix/features/events/domain/constants/events_domain_constants.dart';
import 'package:eventix/features/events/domain/enums/event_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventStatus - Mapeo desde String', () {
    test('Mapea correctamente el estado activo', () {
      expect(
        EventStatus.fromString(EventsDomainConstants.statusActive),
        equals(EventStatus.active),
      );
    });

    test('Mapea correctamente el estado agotado', () {
      expect(
        EventStatus.fromString(EventsDomainConstants.statusSoldOut),
        equals(EventStatus.soldOut),
      );
    });

    test('Mapea correctamente el estado finalizado', () {
      expect(
        EventStatus.fromString(EventsDomainConstants.statusFinished),
        equals(EventStatus.finished),
      );
    });

    test('Mapea correctamente el estado cancelado', () {
      expect(
        EventStatus.fromString(EventsDomainConstants.statusCancelled),
        equals(EventStatus.cancelled),
      );
    });

    test('Usa el estado activo como fallback ante un valor desconocido', () {
      expect(
        EventStatus.fromString('unknown_value'),
        equals(EventStatus.active),
      );
    });

    test('Usa el estado activo como fallback ante un valor vacío', () {
      expect(
        EventStatus.fromString(''),
        equals(EventStatus.active),
      );
    });
  });

  group('EventStatus - Mapeo a String', () {
    test('Convierte el estado activo al valor de Firestore correspondiente', () {
      expect(
        EventStatus.active.toFirestoreString(),
        equals(EventsDomainConstants.statusActive),
      );
    });

    test('Convierte el estado agotado al valor de Firestore correspondiente', () {
      expect(
        EventStatus.soldOut.toFirestoreString(),
        equals(EventsDomainConstants.statusSoldOut),
      );
    });

    test('Convierte el estado finalizado al valor de Firestore correspondiente', () {
      expect(
        EventStatus.finished.toFirestoreString(),
        equals(EventsDomainConstants.statusFinished),
      );
    });

    test('Convierte el estado cancelado al valor de Firestore correspondiente', () {
      expect(
        EventStatus.cancelled.toFirestoreString(),
        equals(EventsDomainConstants.statusCancelled),
      );
    });
  });

  group('EventStatus - Consistencia', () {
    test('El mapeo es reversible para todos los estados de la escala', () {
      for (final status in EventStatus.values) {
        expect(
          EventStatus.fromString(status.toFirestoreString()),
          equals(status),
          reason: 'El status ${status.name} debería ser igual después del roundtrip',
        );
      }
    });
  });
}
