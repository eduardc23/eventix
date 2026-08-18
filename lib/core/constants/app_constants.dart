abstract final class AppConstants {
  // Errores Genéricos
  static const String networkError =
      'Sin conexión. Verifica tu red e inténtalo de nuevo.';
  static const String timeoutError =
      'El servidor tardó demasiado en responder.';
  static const String serverError = 'Ocurrió un error en el servidor.';
  static const String unknownError = 'Ha ocurrido un error desconocido.';
  static const String rateLimitError =
      'Demasiadas solicitudes. Por favor, inténtalo más tarde.';
  static const String unexpectedError = 'Algo salió mal. Intenta de nuevo.';

  // Errores de Configuración
  static const String configError = 'Error de configuración.';
  static const String configLoadError =
      'Error al cargar la configuración de la aplicación.';

  static String configSectionError(String section) =>
      'Falta o es inválida la sección "$section" en la configuración.';

  // Etiquetas Comunes
  static const String emailLabel = 'Correo electrónico';
  static const String passwordLabel = 'Contraseña';
  static const String openDrawerLabel = 'Abrir menú';
  static const String freeLabel = 'Gratis';

  static String formatPrice(num price, {String freeLabel = freeLabel}) =>
      price == 0 ? freeLabel : '\$${price.toStringAsFixed(0)}';

  // Errores de Validación (Primitivos)
  static const String requiredField = 'Campo requerido.';
  static const String invalidEmail = 'Correo no válido.';
  static const String invalidFormat = 'Formato no válido.';

  static String minLengthError(int min) => 'Mínimo $min caracteres.';

  static String maxLengthError(int max) => 'Máximo $max caracteres.';
}
