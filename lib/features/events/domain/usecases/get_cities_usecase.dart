import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../entities/city_entity.dart';
import '../repositories/events_repository.dart';

class GetCitiesUseCase implements NoParamsUseCase<List<CityEntity>> {
  const GetCitiesUseCase(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<List<CityEntity>, AppFailure>> call() {
    return _repository.getCities();
  }
}
