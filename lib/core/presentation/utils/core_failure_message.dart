import '../../constants/app_strings.dart';
import '../../domain/failures/core_failures.dart';

extension CoreFailureMessageX on CoreFailure {
  String get errorMessage {
    return switch (this) {
      NetworkFailure() => AppStrings.networkError,
      TimeoutFailure() => AppStrings.timeoutError,
      ServerFailure(:final message) => message ?? AppStrings.serverError,
      UnknownFailure() => AppStrings.unknownError,
      RateLimitFailure() => AppStrings.rateLimitError,
    };
  }
}
