import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import '../exceptions/app_exception.dart';
import '../exceptions/core_exceptions.dart';
import '../mappers/firebase_exception_mapper.dart';

/// Mixin para centralizar la ejecución de llamadas a servicios externos
/// (Firebase, APIs, etc.) en los datasources, manejando excepciones técnicas
/// y convirtiéndolas en excepciones de dominio ([AppException]).
///
/// ## Preservación del stack trace
///
/// Cada rama del `catch` usa [Error.throwWithStackTrace] para adjuntar
/// el stack trace original (`st`) a la nueva excepción de dominio.
/// Esto garantiza que herramientas de monitoreo como Crashlytics o Sentry
/// reporten el punto real donde falló la llamada (por ejemplo,
/// `auth_datasource.dart:23`), y no el interior de este mixin.
///
/// La única excepción es el bloque `if (e is AppException)`, que usa
/// `rethrow`: como la excepción no se transforma, `rethrow` ya preserva
/// automáticamente el stack trace original por diseño del lenguaje.
///
/// ## Orden de evaluación
///
/// El `catch` evalúa las condiciones en este orden:
///
/// 1. `mapException` — permite al datasource interceptar errores específicos
///    antes que cualquier otro bloque (ej. códigos de `FirebaseAuthException`).
///    Si retorna `null`, el flujo continúa al siguiente bloque.
/// 2. `FirebaseException` — delega al [FirebaseExceptionMapper] si fue provisto;
///    de lo contrario lanza [UnknownException].
/// 3. `SocketException` → [NetworkException]
/// 4. `TimeoutException` → [RequestTimeoutException]
/// 5. `AppException` — relanza la excepción tal cual (ya está mapeada).
/// 6. Fallback — cualquier error no contemplado lanza [UnknownException].
///    Su presencia en los logs indica un mapeo faltante en el datasource.
mixin DatasourceExecutor {
  /// Ejecuta una acción asíncrona y captura excepciones de infraestructura.
  ///
  /// [firebaseMapper] mapea errores genéricos de Firebase. Es opcional para
  /// datasources que no dependen de Firebase.
  /// [mapException] permite al datasource manejar excepciones específicas
  /// antes del manejo genérico (ej. códigos de `FirebaseAuthException`).
  /// Retornar `null` desde [mapException] delega al siguiente bloque.
  Future<T> execute<T>(
    Future<T> Function() action, {
    FirebaseExceptionMapper? firebaseMapper,
    Object? Function(Object)? mapException,
  }) async {
    try {
      return await action();
    } catch (e, st) {
      // 1. El datasource tiene prioridad para mapear sus errores específicos.
      //    Si retorna null, el control pasa al siguiente bloque.
      if (mapException != null) {
        final mapped = mapException(e);
        if (mapped != null) Error.throwWithStackTrace(mapped, st);
      }

      // 2. Errores genéricos de Firebase: se delegan al mapper o caen al fallback.
      if (e is FirebaseException) {
        if (firebaseMapper == null) {
          Error.throwWithStackTrace(const UnknownException(), st);
        }
        Error.throwWithStackTrace(firebaseMapper.mapFirebase(e), st);
      }

      // 3. Sin conexión a internet.
      if (e is SocketException) {
        Error.throwWithStackTrace(const NetworkException(), st);
      }

      // 4. La operación superó su tiempo límite.
      if (e is TimeoutException) {
        Error.throwWithStackTrace(const RequestTimeoutException(), st);
      }

      // 5. La excepción ya fue mapeada a dominio en un nivel anterior.
      //    rethrow preserva el stack trace original sin necesidad de Error.throwWithStackTrace.
      if (e is AppException) rethrow;

      // 6. Red de seguridad: cualquier error no contemplado.
      //    Su presencia en los logs indica un mapeo faltante en el datasource.
      Error.throwWithStackTrace(const UnknownException(), st);
    }
  }
}


