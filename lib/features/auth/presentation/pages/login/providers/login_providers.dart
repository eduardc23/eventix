import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/result/result.dart';
import '../../../../di/auth_di_providers.dart';
import '../../../../domain/use_cases/sign_in_use_case.dart';
import 'login_state.dart';

part 'login_providers.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState.initial();

  Future<void> signIn(String email, String password) async {
    state = const LoginState.loading();
    final result = await ref.read(signInUseCaseProvider)(
      SignInParams(email: email, password: password),
    );

    if (!ref.mounted) return;

    state = switch (result) {
      Success() => const LoginState.initial(),
      Error(error: final failure) => LoginState.failure(failure: failure),
    };
  }
}
