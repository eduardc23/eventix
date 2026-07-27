import '../../../../core/data/mappers/core_exception_mapper.dart';
import '../../../../core/data/utils/repository_executor_utils.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_datasource.dart';
import '../mappers/category_mapper.dart';
import '../mappers/city_mapper.dart';
import '../mappers/event_mapper.dart';

class EventsRepositoryImpl with RepositoryExecutor implements EventsRepository {
  const EventsRepositoryImpl({
    required this._dataSource,
    required this._eventMapper,
    required this._categoryMapper,
    required this._cityMapper,
    required this._coreMapper,
  });

  final EventsDataSource _dataSource;
  final EventMapper _eventMapper;
  final CategoryMapper _categoryMapper;
  final CityMapper _cityMapper;
  final CoreExceptionMapper _coreMapper;

  @override
  Future<Result<List<EventEntity>, AppFailure>> getEvents({
    String? categoryId,
    String? cityId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      execute(
        () async {
          final models = await _dataSource.getEvents(
            categoryId: categoryId,
            cityId: cityId,
            startDate: startDate,
            endDate: endDate,
          );
          return _eventMapper.toEntityList(models);
        },
        coreMapper: _coreMapper,
      );

  @override
  Future<Result<List<CategoryEntity>, AppFailure>> getCategories() => execute(
        () async {
          final models = await _dataSource.getCategories();
          return _categoryMapper.toEntityList(models);
        },
        coreMapper: _coreMapper,
      );

  @override
  Future<Result<List<CityEntity>, AppFailure>> getCities() => execute(
        () async {
          final models = await _dataSource.getCities();
          return _cityMapper.toEntityList(models);
        },
        coreMapper: _coreMapper,
      );
}
