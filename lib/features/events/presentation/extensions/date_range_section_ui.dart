import '../../domain/filters/event_filter.dart';
import '../constants/events_strings.dart';

extension DateRangeSectionUiX on DateFilter? {
  /// Retorna el texto exacto que debe mostrar el Chip de rango personalizado
  String toCustomRangeLabel() {
    final filter = this;

    // Si no hay filtro, o el filtro activo es una opción rápida (Today, This Week...),
    // este botón específico debe invitar a seleccionar un rango.
    if (filter == null || filter is DateFilterQuick) {
      return EventsStrings.selectDateRange;
    }

    // Llegado a este punto, Dart sabe con certeza que es un DateFilterRange (Smart Casting)
    if (filter is DateFilterRange) {
      String formatDate(DateTime date) =>
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

      if (filter.from == filter.to) {
        return formatDate(filter.from);
      }
      return '${formatDate(filter.from)} - ${formatDate(filter.to)}';
    }

    return EventsStrings.selectDateRange;
  }
}
