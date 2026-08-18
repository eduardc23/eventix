extension BookingIntX on int {
  /// Formatea la cantidad de entradas para visualización (ej. "1 entrada" o "5 entradas")
  String toTicketsLabel() => switch (this) {
        1 => '1 entrada',
        _ => '$this entradas',
      };

  /// Formatea la cantidad de entradas para lectura semántica (ej. "una entrada" o "5 entradas")
  String toTicketsSemanticLabel() => switch (this) {
        1 => 'una entrada',
        _ => '$this entradas',
      };

  /// Formatea la cantidad de reservas para lectura semántica (ej. "una reserva" o "3 reservas")
  String toBookingsSemanticLabel() => switch (this) {
        1 => 'una reserva',
        _ => '$this reservas',
      };
}
