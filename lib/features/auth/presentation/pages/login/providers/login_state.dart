import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../core/domain/failures/app_failure.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;

  const factory LoginState.loading() = _Loading;

  const factory LoginState.success() = _Success;

  const factory LoginState.failure({required AppFailure failure}) = _Failure;
}
