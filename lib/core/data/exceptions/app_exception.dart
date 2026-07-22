/// Clase base para todas las excepciones de la aplicación.
///
/// Toda excepción de la app debe extender [AppException] para poder
/// capturarse de forma genérica en cualquier capa cuando sea necesario.
///
/// [message] es opcional y está destinado únicamente a logging/debugging interno.
/// Nunca mostrar el mensaje crudo de una excepción directamente al usuario.
abstract class AppException implements Exception {
  final String? message;

  const AppException({this.message});
}
