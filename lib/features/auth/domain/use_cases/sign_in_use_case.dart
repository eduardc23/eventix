import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<void, SignInParams> {
  SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void, AppFailure>> call(SignInParams params) {
    return _repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;
}
