import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

/// Provider global de la configuración de la app.
/// Se inicializa en main.dart vía overrides.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError(
    'appConfigProvider must be initialized with an override in main.dart',
  );
});
