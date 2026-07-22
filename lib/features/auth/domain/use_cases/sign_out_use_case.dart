import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements NoParamsUseCase<void> {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void, AppFailure>> call() {
    return _repository.signOut();
  }
}