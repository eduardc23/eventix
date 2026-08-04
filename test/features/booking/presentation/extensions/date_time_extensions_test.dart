import 'package:eventix/features/booking/presentation/constants/booking_strings.dart';
import 'package:eventix/features/booking/presentation/extensions/date_time_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExtensionsX - Etiquetas de Tiempo de Reserva', () {
    test('Retorna "Hoy" cuando la fecha coincide con el día actual', () {
      final date = DateTime.now();
      expect(date.bookingTimeLabel, equals(BookingStrings.today));
    });

    test('Retorna "Mañana" cuando la diferencia es exactamente de 1 día', () {
      final date = DateTime.now().add(const Duration(days: 1));
      expect(date.bookingTimeLabel, equals(BookingStrings.tomorrow));
    });

    test('Retorna la etiqueta "En X días" para una diferencia de 5 días', () {
      final date = DateTime.now().add(const Duration(days: 5));
      expect(date.bookingTimeLabel, equals('En 5 días'));
    });

    test('Retorna la etiqueta "En X días" para diferencias grandes de 30 días', () {
      final date = DateTime.now().add(const Duration(days: 30));
      expect(date.bookingTimeLabel, equals('En 30 días'));
    });
  });
}
