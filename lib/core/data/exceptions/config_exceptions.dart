import 'app_exception.dart';

sealed class ConfigException extends AppException {
  const ConfigException({super.message});
}

/// Se lanza cuando ocurre un error al cargar la configuración general.
class ConfigLoadException extends ConfigException {
  const ConfigLoadException();
}

/// Se lanza cuando falta una sección específica en la configuración o es inválida.
class ConfigSectionException extends ConfigException {
  final String section;

  const ConfigSectionException({
    required this.section,
    super.message,
  });
}
