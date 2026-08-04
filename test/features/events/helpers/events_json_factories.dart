import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/events/data/constants/events_firestore_constants.dart';

/// Fábrica de mapas JSON para pruebas del feature de eventos.
/// 
/// Esta clase utiliza el patrón "Object Mother" para centralizar la creación de datos 
/// simulados de Firestore. Los parámetros opcionales permiten personalizar casos 
/// específicos de prueba manteniendo un objeto válido por defecto.
/// 
/// Ejemplo de uso para escribir tests expresivos sin duplicar el factory:
/// ```dart
/// // Test: evento agotado
/// final tEventoAgotado = EventsJsonFactories.createEventJson(availableSpots: 0);
/// 
/// // Test: evento cancelado
/// final tEventoCancelado = EventsJsonFactories.createEventJson(status: 'cancelled');
/// 
/// // Test: múltiples eventos con distintos ids
/// final tEventos = [
///   EventsJsonFactories.createEventJson(uid: 'e1', title: 'Evento A'),
///   EventsJsonFactories.createEventJson(uid: 'e2', title: 'Evento B'),
/// ];
/// ```
class EventsJsonFactories {
  
  /// Crea un mapa compatible con `EventModel.fromJson`.
  static Map<String, dynamic> createEventJson({
    String? uid,
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    String? cityId,
    String? cityName,
    DateTime? date,
    int? price,
    int? totalCapacity,
    int? availableSpots,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
  }) {
    return {
      EventsFirestoreConstants.uidField: uid ?? 'event123',
      EventsFirestoreConstants.eventTitleField: title ?? 'Rock al Parque',
      EventsFirestoreConstants.eventDescriptionField: description ?? 'Festival de rock',
      EventsFirestoreConstants.eventCategoryIdField: categoryId ?? 'catRock',
      EventsFirestoreConstants.eventCategoryNameField: categoryName ?? 'Rock',
      EventsFirestoreConstants.eventCityIdField: cityId ?? 'cityBog',
      EventsFirestoreConstants.eventCityNameField: cityName ?? 'Bogotá',
      EventsFirestoreConstants.eventDateField: Timestamp.fromDate(date ?? DateTime(2026, 12, 1)),
      EventsFirestoreConstants.eventPriceField: price ?? 0,
      EventsFirestoreConstants.eventTotalCapacityField: totalCapacity ?? 50000,
      EventsFirestoreConstants.eventAvailableSpotsField: availableSpots ?? 10000,
      EventsFirestoreConstants.eventImageUrlField: imageUrl ?? 'https://rock.com/img.png',
      EventsFirestoreConstants.eventStatusField: status ?? 'active',
      EventsFirestoreConstants.createdAtField: Timestamp.fromDate(createdAt ?? DateTime(2026, 11, 1)),
    };
  }

  /// Crea un mapa compatible con `CategoryModel.fromJson`.
  static Map<String, dynamic> createCategoryJson({
    String? name,
    String? uid,
  }) {
    return {
      EventsFirestoreConstants.uidField: uid ?? 'cat123',
      EventsFirestoreConstants.nameField: name ?? 'Música',
    };
  }

  /// Crea un mapa compatible con `CityModel.fromJson`.
  static Map<String, dynamic> createCityJson({
    String? name,
    String? department,
    String? uid,
  }) {
    return {
      EventsFirestoreConstants.uidField: uid ?? 'city123',
      EventsFirestoreConstants.nameField: name ?? 'Bogotá',
      EventsFirestoreConstants.cityDepartmentField: department ?? 'Cundinamarca',
    };
  }
}
