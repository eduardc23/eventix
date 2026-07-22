import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/result/result.dart';
import '../../di/auth_di_providers.dart';

part 'sign_out_provider.g.dart';

@riverpod
class SignOutNotifier extends _$SignOutNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(signOutUseCaseProvider).call();
    state = switch (result) {
      Success() => const AsyncData(null),
      Error(error: final failure) => AsyncError(failure, StackTrace.current),
    };
  }
}
