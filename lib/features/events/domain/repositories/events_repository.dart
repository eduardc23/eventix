import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../entities/category_entity.dart';
import '../entities/city_entity.dart';
import '../entities/event_entity.dart';

abstract interface class EventsRepository {
  /// Retorna la lista de eventos con filtros opcionales.
  Future<Result<List<EventEntity>, AppFailure>> getEvents({
    String? categoryId,
    String? cityId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Retorna todas las categorías disponibles.
  Future<Result<List<CategoryEntity>, AppFailure>> getCategories();

  /// Retorna todas las ciudades disponibles.
  Future<Result<List<CityEntity>, AppFailure>> getCities();
}
