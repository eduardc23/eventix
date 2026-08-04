import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/event_active_filters_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

class TestAppliedEventFilters extends AppliedEventFilters {
  @override
  EventFilters build() => const EventFilters(
        category: ActiveFilter(id: 'cat-1', name: 'Música'),
        city: ActiveFilter(id: 'city-1', name: 'Madrid'),
      );
}

class TestAppliedDateFilter extends AppliedEventFilters {
  @override
  EventFilters build() => EventFilters(
        date: DateFilter.range(
          from: DateTime(2024, 10, 10),
          to: DateTime(2024, 10, 11),
        ),
      );
}

void main() {
  group('EventActiveFiltersBar - Renderizado', () {
    testWidgets('No se muestra ningún elemento cuando no existen filtros activos', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: EventActiveFiltersBar()),
        overrides: [
          appliedEventFiltersProvider.overrideWith(AppliedEventFilters.new),
        ],
      );

      expect(find.text(EventsStrings.clearFilters), findsNothing);
    });

    testWidgets(
      'Se visualizan los filtros activos y el botón para limpiar todo',
      (WidgetTester tester) async {
        await tester.pumpApp(
          const Scaffold(body: EventActiveFiltersBar()),
          overrides: [
            appliedEventFiltersProvider.overrideWith(TestAppliedEventFilters.new),
          ],
        );

        expect(find.text('Música'), findsOneWidget);
        expect(find.text('Madrid'), findsOneWidget);
        expect(find.text(EventsStrings.clearFilters), findsOneWidget);
        expect(find.bySubtype<AppChip>(), findsNWidgets(2));
      },
    );

    testWidgets('El filtro de fecha muestra el texto formateado correctamente', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: EventActiveFiltersBar()),
        overrides: [
          appliedEventFiltersProvider.overrideWith(TestAppliedDateFilter.new),
        ],
      );

      expect(find.text('10/10/2024 - 11/10/2024'), findsOneWidget);
    });
  });

  group('EventActiveFiltersBar - Comportamiento', () {
    testWidgets('Al pulsar el botón de limpiar se eliminan todos los filtros aplicados', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: EventActiveFiltersBar()),
        overrides: [
          appliedEventFiltersProvider.overrideWith(TestAppliedEventFilters.new),
        ],
      );

      await tester.tap(find.text(EventsStrings.clearFilters));
      await tester.pump();

      expect(find.text('Música'), findsNothing);
      expect(find.text('Madrid'), findsNothing);
      expect(find.text(EventsStrings.clearFilters), findsNothing);
    });

    testWidgets('Al pulsar sobre un filtro individual se elimina dicho filtro de la selección', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: EventActiveFiltersBar()),
        overrides: [
          appliedEventFiltersProvider.overrideWith(TestAppliedEventFilters.new),
        ],
      );

      // Pulsamos sobre el chip de 'Música'
      await tester.tap(find.text('Música'));
      await tester.pump();

      expect(find.text('Música'), findsNothing);
      expect(find.text('Madrid'), findsOneWidget);
    });
  });
}
