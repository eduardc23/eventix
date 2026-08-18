import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'test_app_config.dart';

extension PumpApp on WidgetTester {
  /// Envuelve el [widget] en un [ProviderScope] y [MaterialApp] con el tema de la aplicación.
  ///
  /// Permite inyectar [overrides] para simular estados de proveedores de Riverpod.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    bool wrapWithMaterialApp = true,
    AppConfig? appConfig,
  }) async {
    await initializeDateFormatting();
    return pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(testAppConfig),
          ...overrides,
        ],
        child: wrapWithMaterialApp
            ? MaterialApp(theme: AppTheme.light, home: widget)
            : widget,
      ),
    );
  }
}
