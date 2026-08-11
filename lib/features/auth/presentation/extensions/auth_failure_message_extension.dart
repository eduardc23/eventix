import '../../../../core/config/app_config.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/failures/core_failures.dart';
import '../../../../core/presentation/extensions/core_failure_message_extension.dart';
import '../../domain/failures/auth_failure.dart';

extension AuthFailureMessageX on AppFailure {
  String toAuthMessage(AppConfig config) {
    return switch (this) {
      // Manejo de errores específicos de Auth
      AuthFailure authFailure => switch (authFailure) {
        InvalidCredentialsFailure() => config.banners.auth.invalidCredentials,
        EmailAlreadyInUseFailure() => config.banners.auth.emailAlreadyInUse,
        UnexpectedAuthFailure() => config.banners.auth.unexpectedError,
      },

      // Delegación a la extensión del Core
      CoreFailure coreFailure => coreFailure.errorMessage,

      // Fallback
      _ => config.banners.auth.unexpectedError,
    };
  }
}
