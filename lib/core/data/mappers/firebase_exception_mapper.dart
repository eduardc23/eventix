import 'package:firebase_core/firebase_core.dart';

import '../../constants/firebase_common_codes.dart';
import '../exceptions/core_exceptions.dart';

/// Contrato para mapear excepciones genéricas de Firebase y de plataforma
/// a [CoreException]s de dominio.
///
/// Vive en Core porque es transversal: cualquier datasource que use Firebase
/// o realice llamadas de red puede inyectarlo y reutilizarlo sin duplicar lógica.
abstract interface class FirebaseExceptionMapper {
  /// Convierte un [FirebaseException] genérico en la [CoreException] correspondiente.
  ///
  /// Usar cuando el datasource captura [FirebaseException] fuera del contexto
  /// de un servicio específico (Auth, Storage, Firestore).
  CoreException mapFirebase(FirebaseException exception);
}

/// Implementación por defecto de [FirebaseExceptionMapper].
/// [mapFirebase] usa [ServerException] como fallback explícito e informativo:
/// cualquier código de Firebase no reconocido se considera un error de servidor
/// y propaga el mensaje original para facilitar el diagnóstico.
///
/// [mapPlatform] usa [UnknownException] como fallback: si aparece en
/// producción, indica una excepción de plataforma no contemplada.
class FirebaseExceptionMapperImpl implements FirebaseExceptionMapper {
  const FirebaseExceptionMapperImpl();

  @override
  CoreException mapFirebase(FirebaseException exception) {
    return switch (exception.code) {
      FirebaseCommonCodes.tooManyRequests => const RateLimitException(),
      FirebaseCommonCodes.networkRequestFailed ||
      FirebaseCommonCodes.unavailable =>
        const NetworkException(),
      FirebaseCommonCodes.deadlineExceeded => const RequestTimeoutException(),
      // Código no reconocido: se trata como error de servidor y se
      // propaga el mensaje original
      _ => ServerException(message: exception.message),
    };
  }
}
