import '../../domain/failures/app_failure.dart';
import '../../domain/failures/config_failures.dart';
import '../exceptions/config_exceptions.dart';

/// Contrato para convertir una [ConfigException] en su [AppFailure] correspondiente.
abstract interface class ConfigExceptionMapper {
  /// Convierte [exception] en el [AppFailure] correspondiente.
  AppFailure map(ConfigException exception);
}

/// Implementación por defecto de [ConfigExceptionMapper].
class ConfigExceptionMapperImpl implements ConfigExceptionMapper {
  const ConfigExceptionMapperImpl();

  @override
  AppFailure map(ConfigException exception) => switch (exception) {
    ConfigLoadException() => const ConfigFailure.load(),
    ConfigSectionException(:final section) => ConfigFailure.section(
      section: section,
    ),
  };
}
