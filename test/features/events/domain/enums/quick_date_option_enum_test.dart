import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuickDateOption - Hoy', () {
    test('El inicio del rango es el comienzo del día actual', () {
      final now = DateTime(2026, 7, 15, 14, 30); // miércoles, mediodía
      final range = QuickDateOption.today.range(now);

      expect(range.start, equals(DateTime(2026, 7, 15)));
    });

    test('El fin del rango es el comienzo del día siguiente', () {
      final now = DateTime(2026, 7, 15, 14, 30);
      final range = QuickDateOption.today.range(now);

      expect(range.end, equals(DateTime(2026, 7, 16)));
    });
  });

  group('QuickDateOption - Esta Semana', () {
    test('El rango comienza el día de hoy', () {
      final now = DateTime(2026, 7, 15); // miércoles
      final range = QuickDateOption.thisWeek.range(now);

      expect(range.start, equals(DateTime(2026, 7, 15)));
    });

    test('El rango termina el domingo de la semana en curso', () {
      final now = DateTime(2026, 7, 15); // miércoles — weekday = 3
      final range = QuickDateOption.thisWeek.range(now);

      // 7 - 3 = 4 días hasta el domingo
      expect(range.end, equals(DateTime(2026, 7, 19)));
    });

    test('El rango termina el mismo día si hoy es domingo', () {
      final now = DateTime(2026, 7, 19); // domingo — weekday = 7
      final range = QuickDateOption.thisWeek.range(now);

      // 7 - 7 = 0 días
      expect(range.end, equals(DateTime(2026, 7, 19)));
    });
  });

  group('QuickDateOption - Este Fin de Semana', () {
    test('El rango comienza el próximo sábado cuando se consulta un lunes', () {
      final now = DateTime(2026, 7, 13); // lunes — weekday = 1
      final range = QuickDateOption.thisWeekend.range(now);

      expect(range.start, equals(DateTime(2026, 7, 18))); // sábado
    });

    test('El rango finaliza el lunes posterior al fin de semana', () {
      final now = DateTime(2026, 7, 13); // lunes
      final range = QuickDateOption.thisWeekend.range(now);

      expect(range.end, equals(DateTime(2026, 7, 20))); // lunes
    });

    test('El rango comienza hoy si ya es sábado', () {
      final now = DateTime(2026, 7, 18); // sábado — weekday = 6
      final range = QuickDateOption.thisWeekend.range(now);

      expect(range.start, equals(DateTime(2026, 7, 18)));
    });

    test('El rango comienza el próximo sábado si se consulta en domingo', () {
      final now = DateTime(2026, 7, 19); // domingo — weekday = 7
      final range = QuickDateOption.thisWeekend.range(now);

      expect(range.start, equals(DateTime(2026, 7, 25)));
    });
  });

  group('QuickDateOption - Este Mes', () {
    test('El rango mensual comienza el día de hoy', () {
      final now = DateTime(2026, 7, 15);
      final range = QuickDateOption.thisMonth.range(now);

      expect(range.start, equals(DateTime(2026, 7, 15)));
    });

    test('El rango mensual termina el último día del mes en curso', () {
      final now = DateTime(2026, 7, 15);
      final range = QuickDateOption.thisMonth.range(now);

      // DateTime(2026, 8, 0) == 31 de julio
      expect(range.end, equals(DateTime(2026, 7, 31)));
    });

    test('El fin de rango respeta los 28 días de febrero en años no bisiestos', () {
      final now = DateTime(2025, 2, 10);
      final range = QuickDateOption.thisMonth.range(now);

      expect(range.end, equals(DateTime(2025, 2, 28)));
    });

    test('El fin de rango respeta los 29 días de febrero en años bisiestos', () {
      final now = DateTime(2028, 2, 10);
      final range = QuickDateOption.thisMonth.range(now);

      expect(range.end, equals(DateTime(2028, 2, 29)));
    });
  });
}
