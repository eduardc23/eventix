import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/extensions/quick_date_option_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuickDateOptionDisplayX - Etiquetas Legibles', () {
    test('Retorna la etiqueta correspondiente para el día de hoy', () {
      expect(QuickDateOption.today.label, equals(EventsStrings.dateToday));
    });

    test('Retorna la etiqueta correspondiente para esta semana', () {
      expect(
        QuickDateOption.thisWeek.label,
        equals(EventsStrings.dateThisWeek),
      );
    });

    test('Retorna la etiqueta correspondiente para este fin de semana', () {
      expect(
        QuickDateOption.thisWeekend.label,
        equals(EventsStrings.dateThisWeekend),
      );
    });

    test('Retorna la etiqueta correspondiente para este mes', () {
      expect(
        QuickDateOption.thisMonth.label,
        equals(EventsStrings.dateThisMonth),
      );
    });

    test('Cada opción del enumerado tiene una etiqueta definida', () {
      for (final option in QuickDateOption.values) {
        expect(
          option.label,
          isNotEmpty,
          reason: 'La opción ${option.name} no tiene una etiqueta definida',
        );
      }
    });
  });
}
