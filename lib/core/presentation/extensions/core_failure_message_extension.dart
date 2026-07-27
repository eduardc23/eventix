import '../../constants/app_constants.dart';
import '../../domain/failures/core_failures.dart';

extension CoreFailureMessageX on CoreFailure {
  String get errorMessage {
    return switch (this) {
      NetworkFailure() => AppConstants.networkError,
      TimeoutFailure() => AppConstants.timeoutError,
      ServerFailure(:final message) => message ?? AppConstants.serverError,
      UnknownFailure() => AppConstants.unknownError,
      RateLimitFailure() => AppConstants.rateLimitError,
    };
  }
}
