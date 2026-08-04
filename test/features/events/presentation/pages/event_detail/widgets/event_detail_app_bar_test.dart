import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';
import '../../../../helpers/events_test_data.dart';

void main() {
  final event = EventsTestData.makeEventEntity();
  group('EventDetailAppBar - Renderizado', () {
    testWidgets('SliverAppBar y FlexibleSpaceBar presentes en la interfaz', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomScrollView(slivers: [EventDetailAppBar(event: event)]),
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    });

    testWidgets('Imagen de fondo renderizada usando AppImage', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomScrollView(slivers: [EventDetailAppBar(event: event)]),
        ),
      );

      expect(find.bySubtype<AppImage>(), findsOneWidget);
    });
  });

  group('EventDetailAppBar - Configuración', () {
    testWidgets(
      'Altura expandida y propiedades de visualización configuradas correctamente',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Scaffold(
            body: CustomScrollView(slivers: [EventDetailAppBar(event: event)]),
          ),
        );

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, 300.0);
        expect(sliverAppBar.pinned, isTrue);
        expect(sliverAppBar.stretch, isTrue);
      },
    );
  });
}
