import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/booking/presentation/constants/booking_strings.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/booking_list_page.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_list_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('BookingListPage - Renderizado', () {
    testWidgets(
      'Componentes principales (Scaffold, TopBar y Body) presentes en la interfaz',
      (WidgetTester tester) async {
        await tester.pumpApp(BookingListPage());

        expect(find.byType(AppScaffold), findsOneWidget);
        expect(find.byType(AppTopBar), findsOneWidget);
        expect(find.byType(BookingListBody), findsOneWidget);
      },
    );
  });

  group('BookingListPage - Contenido', () {
    testWidgets('Título de la página visible en la barra superior', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(BookingListPage());

      expect(find.text(BookingStrings.bookingListTitle), findsOneWidget);
    });
  });
}
