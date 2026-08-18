import 'package:eventix/core/presentation/extensions/date_time_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    await initializeDateFormatting('en');
  });

  group('AppDateTimeX - Formateo de Fecha de Evento', () {
    test('Formatea la medianoche correctamente', () {
      final dt = DateTime(2025, 1, 1, 0, 0);
      final result = dt.toEventDate();

      expect(result, contains('00:00 h'));
    });

    test('usa el locale indicado al pasar inglés y español como parámetro', () {
      // 2025-09-20 es sábado → "sáb." en español, "Sat" en inglés.
      // Usar el nombre del día como discriminador real entre locales.
      final dt = DateTime(2025, 9, 20, 20, 0);

      final resultEs = dt.toEventDate(locale: 'es');
      final resultEn = dt.toEventDate(locale: 'en');

      // Validamos que la abreviatura del día cambie según el locale proporcionado
      expect(resultEn.toLowerCase(), contains('sat'));
      expect(resultEs.toLowerCase(), isNot(contains('sat')));
      expect(resultEn, contains('20:00 h'));
      expect(resultEs, contains('20:00 h'));
    });
  });
}
