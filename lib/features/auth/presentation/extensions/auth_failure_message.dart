import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/failures/core_failures.dart';
import '../../../../core/presentation/utils/core_failure_message.dart';
import '../../domain/failures/auth_failure.dart';
import '../constants/auth_strings.dart';

extension AuthFailureMessageX on AppFailure {
  String get toAuthMessage {
    return switch (this) {
      // Manejo de errores específicos de Auth
      AuthFailure authFailure => switch (authFailure) {
        InvalidCredentialsFailure() => AuthStrings.invalidAuthError,
        EmailAlreadyInUseFailure() => AuthStrings.emailAlreadyInUseError,
        UnexpectedAuthFailure() => AuthStrings.unexpectedAuthError,
      },

      // Delegación a la extensión del Core
      CoreFailure coreFailure => coreFailure.errorMessage,

      // Fallback
      _ => AuthStrings.unexpectedAuthError,
    };
  }
}
