import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/events_strings.dart';

/// Un widget genérico para manejar estados de carga y error en secciones de filtros
/// que dependen de datos asíncronos (como categorías o ciudades).
class AsyncFilterSection<T> extends StatelessWidget {
  const AsyncFilterSection({
    super.key,
    required this.state,
    required this.icon,
    required this.errorTitle,
    required this.onRetry,
    required this.builder,
  });

  /// El estado asíncrono que contiene la lista de ítems.
  final AsyncValue<List<T>> state;

  /// El ícono a mostrar en caso de error o estado vacío.
  final IconData icon;

  /// El título del error a mostrar si la carga falla.
  final String errorTitle;

  /// Callback para reintentar la carga.
  final VoidCallback onRetry;

  /// Builder que define cómo mostrar los datos cuando están disponibles.
  final Widget Function(List<T> items) builder;

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (items) => builder(items),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: AppLoader.medium(semanticsLabel: EventsStrings.loadingFilters),
        ),
      ),
      error: (error, stack) => AppEmptyState(
        icon: icon,
        title: errorTitle,
        actionLabel: EventsStrings.retryAction,
        onAction: onRetry,
      ),
    );
  }
}
