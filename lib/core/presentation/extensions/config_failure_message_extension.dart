import '../../constants/app_constants.dart';
import '../../domain/failures/config_failures.dart';

extension ConfigFailureMessageX on ConfigFailure {
  String get toErrorMessage {
    return switch (this) {
      ConfigLoadFailure() => AppConstants.configLoadError,
      ConfigSectionFailure(:final section) => AppConstants.configSectionError(
        section,
      ),
    };
  }
}
