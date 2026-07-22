import '../models/category_model.dart';
import '../models/city_model.dart';
import '../models/event_model.dart';

abstract interface class EventsDataSource {
  /// Retorna eventos con filtros opcionales.
  Future<List<EventModel>> getEvents({
    String? categoryId,
    String? cityId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Retorna todas las categorías disponibles.
  Future<List<CategoryModel>> getCategories();

  /// Retorna todas las ciudades disponibles.
  Future<List<CityModel>> getCities();
}
