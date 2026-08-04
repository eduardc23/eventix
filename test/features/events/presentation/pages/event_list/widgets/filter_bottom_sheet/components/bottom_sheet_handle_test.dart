import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/components/bottom_sheet_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('BottomSheetHandle - Renderizado', () {
    testWidgets('Visualiza correctamente el indicador visual del bottom sheet', (tester) async {
      await tester.pumpApp(const Scaffold(body: BottomSheetHandle()));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.grey[300]);
      expect(decoration.borderRadius, isNotNull);
    });
  });
}
