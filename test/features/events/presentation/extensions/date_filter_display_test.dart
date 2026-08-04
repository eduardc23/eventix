import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/extensions/date_filter_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateFilterDisplayX - Representación Visual', () {
    group('Opciones Rápidas', () {
      test('Muestra solo la fecha de inicio sin rango cuando la opción es hoy', () {
        final now = DateTime(2026, 7, 20);
        const filter = DateFilter.quick(option: QuickDateOption.today);

        expect(filter.toDisplayString(now), equals('20/07/2026'));
      });

      test('Formatea correctamente días y meses con un solo dígito para el día de hoy', () {
        final now = DateTime(2026, 1, 5);
        const filter = DateFilter.quick(option: QuickDateOption.today);

        expect(filter.toDisplayString(now), equals('05/01/2026'));
      });

      test('Muestra el rango desde hoy hasta el domingo para la opción de esta semana', () {
        // Miércoles 15/07/2026 — faltan 4 días para el domingo 19/07/2026
        final now = DateTime(2026, 7, 15);
        const filter = DateFilter.quick(option: QuickDateOption.thisWeek);

        expect(filter.toDisplayString(now), equals('15/07/2026 - 19/07/2026'));
      });

      test('Muestra el mismo día como rango cuando hoy es domingo en la opción de esta semana', () {
        // Domingo 19/07/2026
        final now = DateTime(2026, 7, 19);
        const filter = DateFilter.quick(option: QuickDateOption.thisWeek);

        expect(filter.toDisplayString(now), equals('19/07/2026 - 19/07/2026'));
      });

      test('Muestra el fin de semana próximo cuando se consulta un lunes', () {
        // Lunes 13/07/2026 — sábado 18/07/2026, fin lunes 20/07/2026
        final now = DateTime(2026, 7, 13);
        const filter = DateFilter.quick(option: QuickDateOption.thisWeekend);

        expect(filter.toDisplayString(now), equals('18/07/2026 - 20/07/2026'));
      });

      test('Muestra desde hoy cuando hoy es sábado para la opción de fin de semana', () {
        final now = DateTime(2026, 7, 18);
        const filter = DateFilter.quick(option: QuickDateOption.thisWeekend);

        expect(filter.toDisplayString(now), equals('18/07/2026 - 20/07/2026'));
      });

      test('Muestra desde hoy hasta el último día del mes en curso', () {
        final now = DateTime(2026, 7, 15);
        const filter = DateFilter.quick(option: QuickDateOption.thisMonth);

        expect(filter.toDisplayString(now), equals('15/07/2026 - 31/07/2026'));
      });

      test('Respeta los 28 días de febrero en años no bisiestos para el rango mensual', () {
        final now = DateTime(2025, 2, 10);
        const filter = DateFilter.quick(option: QuickDateOption.thisMonth);

        expect(filter.toDisplayString(now), equals('10/02/2025 - 28/02/2025'));
      });

      test('Respeta los 29 días de febrero en años bisiestos para el rango mensual', () {
        final now = DateTime(2028, 2, 10);
        const filter = DateFilter.quick(option: QuickDateOption.thisMonth);

        expect(filter.toDisplayString(now), equals('10/02/2028 - 29/02/2028'));
      });
    });

    group('Rangos Personalizados', () {
      test('Muestra el rango personalizado formateado con DD/MM/YYYY', () {
        final filter = DateFilter.range(
          from: DateTime(2026, 7, 20),
          to: DateTime(2026, 7, 26),
        );

        expect(filter.toDisplayString(), equals('20/07/2026 - 26/07/2026'));
      });

      test('Aplica ceros a la izquierda para días y meses de un solo dígito', () {
        final filter = DateFilter.range(
          from: DateTime(2026, 1, 5),
          to: DateTime(2026, 3, 9),
        );

        expect(filter.toDisplayString(), equals('05/01/2026 - 09/03/2026'));
      });

      test('Ignora el parámetro de tiempo actual ya que utiliza fechas explícitas', () {
        final filter = DateFilter.range(
          from: DateTime(2026, 7, 20),
          to: DateTime(2026, 7, 26),
        );

        expect(
          filter.toDisplayString(DateTime(2099, 1, 1)),
          equals('20/07/2026 - 26/07/2026'),
        );
      });
    });
  });
}
