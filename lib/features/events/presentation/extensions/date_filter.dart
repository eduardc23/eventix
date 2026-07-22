import '../../domain/filters/event_filter.dart';
import '../constants/events_strings.dart';

extension DateFilterDisplayX on DateFilter {
  /// Retorna el rango de fechas formateado para mostrar en la UI (ej. "20/07/2026" o "20/07/2026 - 26/07/2026")
  String toDisplayString() {
    // Helper local para formatear una fecha a DD/MM/YYYY
    String formatDate(DateTime date) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month/${date.year}';
    }

    return switch (this) {
      // Caso 1: Es una opción rápida (QuickDateOption)
      DateFilterQuick(:final option) => switch (option) {
        // Si es hoy, solo mostramos la fecha de inicio
        QuickDateOption.today => formatDate(option.range.start),

        // Para las demás opciones, mostramos el rango "Inicio - Fin"
        _ =>
          '${formatDate(option.range.start)} - ${formatDate(option.range.end)}',
      },

      // Caso 2: Es un rango personalizado elegido por el usuario
      DateFilterRange(:final from, :final to) =>
        '${formatDate(from)} - ${formatDate(to)}',
    };
  }
}

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

extension QuickDateOptionDisplayX on QuickDateOption {
  /// Retorna el texto legible para el usuario en la UI
  String get label {
    return switch (this) {
      QuickDateOption.today => EventsStrings.dateToday,
      QuickDateOption.thisWeek => EventsStrings.dateThisWeek,
      QuickDateOption.thisWeekend => EventsStrings.dateThisWeekend,
      QuickDateOption.thisMonth => EventsStrings.dateThisMonth,
    };
  }
}
