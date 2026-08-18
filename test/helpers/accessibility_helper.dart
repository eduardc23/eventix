import 'package:flutter_test/flutter_test.dart';

extension AccessibilityHelper on WidgetTester {
  /// Verifica que el widget actual cumpla con las guías de accesibilidad básicas.
  Future<void> checkAccessibility() async {
    await expectLater(this, meetsGuideline(textContrastGuideline));
    await expectLater(this, meetsGuideline(androidTapTargetGuideline));
    await expectLater(this, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(this, meetsGuideline(labeledTapTargetGuideline));
  }
}
