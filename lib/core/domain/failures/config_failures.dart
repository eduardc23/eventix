import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_failure.dart';

part 'config_failures.freezed.dart';

@freezed
sealed class ConfigFailure with _$ConfigFailure implements AppFailure {
  const factory ConfigFailure.load() = ConfigLoadFailure;

  const factory ConfigFailure.section({required String section}) =
      ConfigSectionFailure;
}
