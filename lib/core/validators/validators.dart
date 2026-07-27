import '../constants/app_constants.dart';

/// Reglas de validación primitivas, puras y reutilizables.
class Validators {
  Validators._();

  /// Ejecuta [validators] en orden y devuelve el primer error encontrado.
  static String? compose(
    List<String? Function(String?)> validators,
    String? value,
  ) {
    for (final v in validators) {
      final error = v(value);
      if (error != null) return error;
    }
    return null;
  }

  static String? required(
    String? value, {
    String message = AppConstants.requiredField,
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? minLength(String? value, int min, {String? message}) {
    if (value != null && value.trim().length < min) {
      return message ?? AppConstants.minLengthError(min);
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? message}) {
    if (value != null && value.trim().length > max) {
      return message ?? AppConstants.maxLengthError(max);
    }
    return null;
  }

  static String? email(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null; // required lo maneja
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) {
      return message ?? AppConstants.invalidEmail;
    }
    return null;
  }

  static String? pattern(
    String? value,
    RegExp regex, {
    String message = AppConstants.invalidFormat,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    if (!regex.hasMatch(value.trim())) return message;
    return null;
  }
}
