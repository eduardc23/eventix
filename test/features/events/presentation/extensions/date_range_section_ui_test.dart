import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/extensions/date_range_section_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRangeSectionUiX - Etiquetas de Rango', () {
    test(
      'Muestra la invitación a seleccionar rango cuando no hay filtro activo',
      () {
        const DateFilter? filter = null;
        expect(
          filter.toCustomRangeLabel(),
          equals(EventsStrings.selectDateRange),
        );
      },
    );

    test(
      'Muestra la invitación a seleccionar rango cuando el filtro es una opción rápida',
      () {
        const DateFilter filter = DateFilter.quick(
          option: QuickDateOption.today,
        );
        expect(
          filter.toCustomRangeLabel(),
          equals(EventsStrings.selectDateRange),
        );
      },
    );

    test(
      'Muestra una fecha única cuando el rango personalizado tiene el mismo inicio y fin',
      () {
        final date = DateTime(2026, 7, 20);
        final DateFilter filter = DateFilter.range(from: date, to: date);

        expect(filter.toCustomRangeLabel(), equals('20/07/2026'));
      },
    );

    test(
      'Muestra el rango completo para selecciones personalizadas de varios días',
      () {
        final DateFilter filter = DateFilter.range(
          from: DateTime(2026, 7, 20),
          to: DateTime(2026, 7, 26),
        );

        expect(filter.toCustomRangeLabel(), equals('20/07/2026 - 26/07/2026'));
      },
    );

    test(
      'Aplica el formato de fecha con ceros a la izquierda para días y meses menores a diez',
      () {
        final DateFilter filter = DateFilter.range(
          from: DateTime(2026, 1, 5),
          to: DateTime(2026, 3, 9),
        );

        expect(filter.toCustomRangeLabel(), equals('05/01/2026 - 09/03/2026'));
      },
    );
  });
}
