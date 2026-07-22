import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/result/result.dart';
import '../../../../di/auth_di_providers.dart';
import '../../../../domain/use_cases/sign_up_use_case.dart';
import 'register_state.dart';

part 'register_providers.g.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() => const RegisterState.initial();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const RegisterState.loading();
    final authResult = await ref.read(signUpUseCaseProvider)(
      SingUpParams(name: name, email: email, password: password),
    );

    state = switch (authResult) {
      Success() => const RegisterState.success(),
      Error(error: final failure) => RegisterState.failure(failure: failure),
    };
  }
}
