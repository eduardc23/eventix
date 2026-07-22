class AppStrings {
  AppStrings._();

  static const String appName = 'Eventix';

  // Errores Genéricos
  static const String networkError = 'Sin conexión. Verifica tu red e inténtalo de nuevo.';
  static const String timeoutError = 'El servidor tardó demasiado en responder.';
  static const String serverError = 'Ocurrió un error en el servidor.';
  static const String unknownError = 'Ha ocurrido un error desconocido.';
  static const String rateLimitError = 'Demasiadas solicitudes. Por favor, inténtalo más tarde.';
  static const String unexpectedError = 'Algo salió mal. Intenta de nuevo.';

  // Etiquetas Comunes
  static const String emailLabel = 'Correo electrónico';
  static const String passwordLabel = 'Contraseña';

  // Errores de Validación (Primitivos)
  static const String requiredField = 'Campo requerido.';
  static const String invalidEmail = 'Correo no válido.';
  static const String invalidFormat = 'Formato no válido.';
  static String minLengthError(int min) => 'Mínimo $min caracteres.';
  static String maxLengthError(int max) => 'Máximo $max caracteres.';
}
