import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../entities/category_entity.dart';
import '../repositories/events_repository.dart';

class GetCategoriesUseCase implements NoParamsUseCase<List<CategoryEntity>> {
  const GetCategoriesUseCase(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<List<CategoryEntity>, AppFailure>> call() {
    return _repository.getCategories();
  }
}
