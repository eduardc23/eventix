import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import '../exceptions/app_exception.dart';
import '../exceptions/core_exceptions.dart';
import '../mappers/firebase_exception_mapper.dart';

/// Mixin para centralizar la ejecución de llamadas a servicios externos
/// (Firebase, APIs, etc.) en los datasources, manejando excepciones técnicas
/// y convirtiéndolas en excepciones de dominio ([AppException]).
mixin DatasourceExecutor {
  /// Ejecuta una acción asíncrona y captura excepciones de infraestructura.
  ///
  /// [firebaseMapper] mapea errores genéricos de Firebase. Es opcional para
  /// datasources que no dependen de Firebase.
  /// [mapException] permite al datasource manejar excepciones específicas (ej. FirebaseAuth).
  Future<T> execute<T>(
      Future<T> Function() action, {
        FirebaseExceptionMapper? firebaseMapper,
        Object? Function(Object)? mapException,
      }) async {
    try {
      return await action();
    } catch (e) {
      if (mapException != null) {
        final mapped = mapException(e);
        if (mapped != null) throw mapped;
      }

      if (e is FirebaseException) {
        if (firebaseMapper == null) throw const UnknownException();
        throw firebaseMapper.mapFirebase(e);
      }

      if (e is SocketException) {
        throw const NetworkException();
      }

      if (e is TimeoutException) {
        throw const RequestTimeoutException();
      }

      // Si es una excepción que ya es de dominio, la relanzamos
      if (e is AppException) {
        rethrow;
      }

      // Para cualquier otro error no contemplado, lanzamos la excepción genérica
      throw const UnknownException();
    }
  }
}