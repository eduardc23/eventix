import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  /// Envuelve el [widget] en un [ProviderScope] y [MaterialApp] con el tema de la aplicación.
  ///
  /// Permite inyectar [overrides] para simular estados de proveedores de Riverpod.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    bool setupIntl = false,
  }) async {
    if (setupIntl) {
      await AppKit.initialize();
    }

    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(theme: AppTheme.light, home: widget),
      ),
    );
  }
}
