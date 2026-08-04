import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/core/data/utils/json_converters_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = TimestampConverter();

  group('TimestampConverter - Deserialización', () {
    test('fromJson convierte un Timestamp a DateTime preservando la precisión', () {
      // Usamos una fecha específica con milisegundos para probar precisión
      final expectedDate = DateTime(2023, 10, 31, 15, 30, 45, 500);
      final timestamp = Timestamp.fromDate(expectedDate);

      final result = converter.fromJson(timestamp);

      expect(result, isA<DateTime>());
      expect(result, equals(expectedDate));
    });
  });

  group('TimestampConverter - Serialización', () {
    test('toJson convierte un DateTime a Timestamp correctamente', () {
      final date = DateTime(2023, 10, 31, 15, 30, 45, 500);
      final expectedTimestamp = Timestamp.fromDate(date);

      final result = converter.toJson(date);

      expect(result, isA<Timestamp>());
      // Timestamp tiene sobreescrito el operador ==, por lo que equals funciona perfecto
      expect(result, equals(expectedTimestamp));
    });
  });

  group('TimestampConverter - Integridad', () {
    test(
      'El ciclo completo (DateTime -> Timestamp -> DateTime) mantiene el valor original',
      () {
        final originalDate = DateTime(2024, 1, 1, 12, 0, 0, 123);

        final timestamp = converter.toJson(originalDate);
        final resultDate = converter.fromJson(timestamp);

        expect(resultDate, equals(originalDate));
      },
    );
  });
}
