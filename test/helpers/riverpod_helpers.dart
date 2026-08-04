import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Crea un [ProviderContainer] para pruebas y registra su eliminación automática.
/// 
/// Esta utilidad centraliza la creación de contenedores de Riverpod, asegurando
/// que se liberen los recursos al finalizar cada prueba mediante [addTearDown].
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer.test(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  addTearDown(container.dispose);

  return container;
}
