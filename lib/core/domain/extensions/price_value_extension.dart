extension PriceValueExtension on num {
  /// Regla de negocio centralizada para determinar si un precio es gratuito.
  bool get isFreePrice => this == 0;
}
