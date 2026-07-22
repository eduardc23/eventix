enum EventStatus {
  active,
  soldOut,
  finished,
  cancelled;

  /// Convierte el string de Firestore al enum.
  static EventStatus fromString(String value) => switch (value) {
    'active'    => EventStatus.active,
    'sold_out'  => EventStatus.soldOut,
    'finished'  => EventStatus.finished,
    'cancelled' => EventStatus.cancelled,
    _           => EventStatus.active,
  };

  /// Convierte el enum al string que espera Firestore.
  String toFirestoreString() => switch (this) {
    EventStatus.active    => 'active',
    EventStatus.soldOut   => 'sold_out',
    EventStatus.finished  => 'finished',
    EventStatus.cancelled => 'cancelled',
  };
}
