import '../../domain/enums/quick_date_option_enum.dart';
import '../../domain/filters/event_filter.dart';

extension DateFilterDisplayX on DateFilter {
  /// Retorna el rango de fechas formateado para mostrar en la UI (ej. "20/07/2026" o "20/07/2026 - 26/07/2026")
  String toDisplayString([DateTime? now]) {
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
        QuickDateOption.today => formatDate(option.range(now).start),

        // Para las demás opciones, mostramos el rango "Inicio - Fin"
        _ =>
          '${formatDate(option.range(now).start)} - ${formatDate(option.range(now).end)}',
      },

      // Caso 2: Es un rango personalizado elegido por el usuario
      DateFilterRange(:final from, :final to) =>
        '${formatDate(from)} - ${formatDate(to)}',
    };
  }
}
