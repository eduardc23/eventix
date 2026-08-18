import 'package:intl/intl.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_locale.dart';
import '../../domain/extensions/price_value_extension.dart';

extension PriceExtensions on num {
  /// Formatea un valor entero como precio (ej. $10000 o "Gratis")
  String toFormattedPrice({String freeLabel = AppConstants.freeLabel}) {
    return AppConstants.formatPrice(this, freeLabel: freeLabel);
  }

  /// Formatea un valor entero para lectura semántica (ej. "10000 pesos" o "Gratis")
  String toSemanticPrice({
    String freeLabel = AppConstants.freeLabel,
    String locale = AppLocale.code,
  }) {
    if (isFreePrice) return freeLabel;
    return NumberFormat.currency(
      locale: locale,
      symbol: 'pesos',
      decimalDigits: 0,
    ).format(this);
  }
}
