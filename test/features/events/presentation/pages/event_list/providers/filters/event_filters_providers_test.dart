import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../helpers/riverpod_helpers.dart';

void main() {
  // ── Fixtures reutilizables ────────────────────────────────────────────────
  final categoryFilter = ActiveFilter(id: 'cat-1', name: 'Rock');
  final cityFilter = ActiveFilter(id: 'city-1', name: 'Bogotá');
  final dateFilter = QuickDateOption.thisWeekend.asDateFilter;

  final fullFilters = EventFilters(
    category: categoryFilter,
    city: cityFilter,
    date: dateFilter,
  );

  group('AppliedEventFilters - Estado y Persistencia', () {
    test('Inicia con filtros vacíos por defecto', () {
      final container = createContainer();

      expect(
        container.read(appliedEventFiltersProvider),
        EventFilters.empty,
      );
    });

    test('La aplicación de filtros reemplaza el estado actual completamente', () {
      final container = createContainer();

      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);

      final state = container.read(appliedEventFiltersProvider);
      expect(state.category, categoryFilter);
      expect(state.city, cityFilter);
      expect(state.date, dateFilter);
    });

    test('La aplicación de filtros vacíos limpia el estado', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);

      container
          .read(appliedEventFiltersProvider.notifier)
          .apply(EventFilters.empty);

      expect(
        container.read(appliedEventFiltersProvider),
        EventFilters.empty,
      );
    });

    test('El limpiado total restablece los filtros a su estado inicial vacío', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);

      container.read(appliedEventFiltersProvider.notifier).clearAll();

      expect(
        container.read(appliedEventFiltersProvider),
        EventFilters.empty,
      );
    });
  });

  group('AppliedEventFilters - Limpiado Individual', () {
    test('El limpiado de categoría solo afecta a la categoría seleccionada', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);

      container.read(appliedEventFiltersProvider.notifier).clearCategory();

      final state = container.read(appliedEventFiltersProvider);
      expect(state.category, isNull);
      expect(state.city, cityFilter);
      expect(state.date, dateFilter);
    });

    test('El limpiado de categoría no produce errores si no hay categoría seleccionada', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(
            EventFilters(city: cityFilter),
          );

      expect(
        () => container
            .read(appliedEventFiltersProvider.notifier)
            .clearCategory(),
        returnsNormally,
      );
      expect(container.read(appliedEventFiltersProvider).city, cityFilter);
    });
  });

  group('DraftEventFilters - Estado Inicial y Sincronización', () {
    test('Inicia con el mismo estado que los filtros aplicados', () {
      final container = createContainer();

      expect(
        container.read(draftEventFiltersProvider),
        EventFilters.empty,
      );
    });

    test('Se sincroniza correctamente con los filtros ya aplicados al iniciar', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);

      final draft = container.read(draftEventFiltersProvider);
      expect(draft.category, categoryFilter);
      expect(draft.city, cityFilter);
      expect(draft.date, dateFilter);
    });
  });

  group('DraftEventFilters - Alternancia de Filtros', () {
    test('La alternancia de categoría selecciona una nueva categoría si no estaba presente', () {
      final container = createContainer();

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      final state = container.read(draftEventFiltersProvider);
      expect(state.category?.id, 'cat-1');
      expect(state.category?.name, 'Rock');
    });

    test('La alternancia de categoría deselecciona la categoría si ya estaba marcada', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      expect(container.read(draftEventFiltersProvider).category, isNull);
    });

    test('La alternancia de categoría reemplaza la selección previa por una nueva', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-2', 'Jazz');

      final state = container.read(draftEventFiltersProvider);
      expect(state.category?.id, 'cat-2');
      expect(state.category?.name, 'Jazz');
    });

    test('La alternancia de ciudad selecciona una nueva ciudad si no estaba presente', () {
      final container = createContainer();

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');

      expect(container.read(draftEventFiltersProvider).city?.id, 'city-1');
    });

    test('La alternancia de ciudad deselecciona la ciudad si ya estaba marcada', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');

      expect(container.read(draftEventFiltersProvider).city, isNull);
    });

    test('La alternancia de ciudad preserva el resto de los filtros seleccionados', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');

      final state = container.read(draftEventFiltersProvider);
      expect(state.category?.id, 'cat-1');
      expect(state.city?.id, 'city-1');
    });
  });

  group('DraftEventFilters - Filtros de Fecha', () {
    test('La selección de fecha rápida establece la opción correspondiente', () {
      final container = createContainer();

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.thisWeekend);

      final state = container.read(draftEventFiltersProvider);
      expect(state.date, isA<DateFilterQuick>());
      expect(
        (state.date as DateFilterQuick).option,
        QuickDateOption.thisWeekend,
      );
    });

    test('La alternancia de la misma fecha rápida elimina el filtro de fecha', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.thisWeekend);

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.thisWeekend);

      expect(container.read(draftEventFiltersProvider).date, isNull);
    });

    test('La selección de una nueva fecha rápida reemplaza la opción anterior', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.thisWeekend);

      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.today);

      final state = container.read(draftEventFiltersProvider);
      expect(
        (state.date as DateFilterQuick).option,
        QuickDateOption.today,
      );
    });

    test('La selección de rango de fechas establece un filtro de rango personalizado', () {
      final container = createContainer();
      final from = DateTime(2025, 8, 1);
      final to = DateTime(2025, 8, 10);

      container
          .read(draftEventFiltersProvider.notifier)
          .selectDateRange(from, to);

      final state = container.read(draftEventFiltersProvider);
      expect(state.date, isA<DateFilterRange>());
      final range = state.date as DateFilterRange;
      expect(range.from, from);
      expect(range.to, to);
    });

    test('El rango de fechas personalizado reemplaza cualquier filtro de fecha rápida previo', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.today);

      container
          .read(draftEventFiltersProvider.notifier)
          .selectDateRange(DateTime(2025, 8, 1), DateTime(2025, 8, 5));

      expect(
        container.read(draftEventFiltersProvider).date,
        isA<DateFilterRange>(),
      );
    });

    test('El limpiado de rango de fechas elimina el filtro de rango personalizado', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .selectDateRange(DateTime(2025, 8, 1), DateTime(2025, 8, 5));

      container.read(draftEventFiltersProvider.notifier).clearDateRange();

      expect(container.read(draftEventFiltersProvider).date, isNull);
    });

    test('El limpiado de rango de fechas no afecta a los filtros de fecha rápida', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.today);

      container.read(draftEventFiltersProvider.notifier).clearDateRange();

      expect(
        container.read(draftEventFiltersProvider).date,
        isA<DateFilterQuick>(),
      );
    });

    test('El limpiado de rango de fechas no produce errores si no hay filtros aplicados', () {
      final container = createContainer();

      expect(
        () => container
            .read(draftEventFiltersProvider.notifier)
            .clearDateRange(),
        returnsNormally,
      );
    });
  });

  group('DraftEventFilters - Acciones Finales', () {
    test('El restablecimiento del borrador limpia todas las selecciones pendientes', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleQuickDate(QuickDateOption.today);

      container.read(draftEventFiltersProvider.notifier).reset();

      expect(
        container.read(draftEventFiltersProvider),
        EventFilters.empty,
      );
    });

    test('La confirmación del borrador aplica los filtros al estado global', () {
      final container = createContainer();
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCity('city-1', 'Bogotá');
      container
          .read(draftEventFiltersProvider.notifier)
          .toggleCategory('cat-1', 'Rock');

      container.read(draftEventFiltersProvider.notifier).commit();

      final applied = container.read(appliedEventFiltersProvider);
      expect(applied.city?.id, 'city-1');
      expect(applied.category?.id, 'cat-1');
    });

    test('La confirmación de un borrador vacío limpia los filtros globales', () {
      final container = createContainer();
      container.read(appliedEventFiltersProvider.notifier).apply(fullFilters);
      
      container.read(draftEventFiltersProvider.notifier).reset();
      container.read(draftEventFiltersProvider.notifier).commit();

      expect(
        container.read(appliedEventFiltersProvider),
        EventFilters.empty,
      );
    });
  });
}
