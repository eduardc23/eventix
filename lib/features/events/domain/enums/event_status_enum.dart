import '../constants/events_domain_constants.dart';

enum EventStatus {
  active,
  soldOut,
  finished,
  cancelled;

  /// Convierte el string de Firestore al enum.
  static EventStatus fromString(String value) => switch (value) {
    EventsDomainConstants.statusActive    => EventStatus.active,
    EventsDomainConstants.statusSoldOut  => EventStatus.soldOut,
    EventsDomainConstants.statusFinished  => EventStatus.finished,
    EventsDomainConstants.statusCancelled => EventStatus.cancelled,
    _           => EventStatus.active,
  };

  /// Convierte el enum al string que espera Firestore.
  String toFirestoreString() => switch (this) {
    EventStatus.active    => EventsDomainConstants.statusActive,
    EventStatus.soldOut   => EventsDomainConstants.statusSoldOut,
    EventStatus.finished  => EventsDomainConstants.statusFinished,
    EventStatus.cancelled => EventsDomainConstants.statusCancelled,
  };
}
