/// Clase sellada que representa el resultado de una operación que puede
/// terminar en éxito o en error.
///
/// [S] es el tipo del valor en caso de éxito.
/// [E] es el tipo del valor en caso de error.
sealed class Result<S, E> {
  const Result();

  /// Retorna `true` si el resultado es una instancia de [Success].
  bool get isSuccess => this is Success<S, E>;

  /// Retorna `true` si el resultado es una instancia de [Error].
  bool get isError => this is Error<S, E>;

  /// Ejecuta uno de los dos callbacks según el estado del resultado.
  ///
  /// Garantiza en tiempo de compilación que ambos casos sean manejados.
  ///
  /// - [success] se invoca con el valor si el resultado es [Success].
  /// - [error] se invoca con el error si el resultado es [Error].
  ///
  /// Retorna el valor producido por el callback ejecutado.
  R when<R>({
    required R Function(S value) success,
    required R Function(E error) error,
  }) => switch (this) {
    Success(value: final v) => success(v),
    Error(error: final e) => error(e),
  };
}

/// Representa una operación que finalizó de forma exitosa.
///
/// Contiene el [value] resultante de tipo [S].
final class Success<S, E> extends Result<S, E> {
  const Success(this.value);

  /// El valor obtenido tras una operación exitosa.
  final S value;
}

/// Representa una operación que finalizó con un error.
///
/// Contiene el [error] producido de tipo [E].
final class Error<S, E> extends Result<S, E> {
  const Error(this.error);

  /// El error o falla producido durante la operación.
  final E error;
}