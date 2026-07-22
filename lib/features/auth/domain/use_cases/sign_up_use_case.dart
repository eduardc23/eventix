import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SingUpParams> {
  SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void, AppFailure>> call(SingUpParams params) {
    return _repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class SingUpParams {
  const SingUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
