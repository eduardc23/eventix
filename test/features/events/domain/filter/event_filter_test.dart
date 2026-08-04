import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventFilters - Estado de Activación', () {
    test('No tiene filtros activos por defecto', () {
      expect(EventFilters.empty.hasActiveFilters, isFalse);
    });

    test('Se considera activo si tiene una ciudad seleccionada', () {
      const filters = EventFilters(
        city: ActiveFilter(id: 'city-1', name: 'Bogotá'),
      );
      expect(filters.hasActiveFilters, isTrue);
    });

    test('Se considera activo si tiene una categoría seleccionada', () {
      const filters = EventFilters(
        category: ActiveFilter(id: 'cat-1', name: 'Tecnología'),
      );
      expect(filters.hasActiveFilters, isTrue);
    });

    test('Se considera activo si tiene un filtro de fecha', () {
      const filters = EventFilters(
        date: DateFilter.quick(option: QuickDateOption.today),
      );
      expect(filters.hasActiveFilters, isTrue);
    });

    test('Se considera activo cuando todos los criterios están presentes', () {
      const filters = EventFilters(
        city: ActiveFilter(id: 'city-1', name: 'Bogotá'),
        category: ActiveFilter(id: 'cat-1', name: 'Tecnología'),
        date: DateFilter.quick(option: QuickDateOption.today),
      );
      expect(filters.hasActiveFilters, isTrue);
    });
  });

  group('EventFilters - Estado Inicial', () {
    test('Todos los filtros son nulos por defecto', () {
      expect(EventFilters.empty.city, isNull);
      expect(EventFilters.empty.category, isNull);
      expect(EventFilters.empty.date, isNull);
    });
  });
}
