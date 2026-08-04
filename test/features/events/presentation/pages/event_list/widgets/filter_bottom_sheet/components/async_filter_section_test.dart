import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/components/async_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('AsyncFilterSection - Estados', () {
    testWidgets('Visualiza el loader mientras el estado se encuentra cargando', (tester) async {
      await tester.pumpApp(
        AsyncFilterSection<String>(
          state: const AsyncValue.loading(),
          icon: Icons.error,
          errorTitle: 'Error',
          onRetry: () {},
          builder: (items) => Container(),
        ),
      );

      expect(find.bySubtype<AppLoader>(), findsOneWidget);
    });

    testWidgets('Muestra el contenido correctamente cuando el estado es exitoso', (tester) async {
      await tester.pumpApp(
        AsyncFilterSection<String>(
          state: const AsyncValue.data(['Item 1']),
          icon: Icons.error,
          errorTitle: 'Error',
          onRetry: () {},
          builder: (items) => Column(
            children: items.map(Text.new).toList(),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.byType(AppLoader), findsNothing);
    });

    testWidgets('Visualiza el estado de error y permite reintentar la acción', (tester) async {
      var retryCalled = false;
      await tester.pumpApp(
        AsyncFilterSection<String>(
          state: AsyncValue.error('Error', StackTrace.empty),
          icon: Icons.location_off,
          errorTitle: 'Error de carga',
          onRetry: () => retryCalled = true,
          builder: (items) => Container(),
        ),
      );

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text('Error de carga'), findsOneWidget);
      expect(find.byIcon(Icons.location_off), findsOneWidget);

      await tester.tap(find.text(EventsStrings.retryAction));
      expect(retryCalled, isTrue);
    });
  });
}
