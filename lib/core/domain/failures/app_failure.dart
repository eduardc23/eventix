import 'package:equatable/equatable.dart';

/// Clase base para todos los failures de la aplicación.
///
/// Un [AppFailure] representa un error ya procesado y listo para ser
/// consumido por la capa de presentación. A diferencia de las excepciones,
/// los failures no contienen detalles técnicos crudos — su propósito es
/// comunicar qué salió mal en términos del dominio.
abstract class AppFailure extends Equatable {
  const AppFailure();

  @override
  List<Object?> get props => [];
}


