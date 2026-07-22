class EventsStrings {
  EventsStrings._();

  // Page Titles
  static const eventsTitle = 'Eventos';
  static const eventDetailTitle = 'Detalle del Evento';

  // Filters
  static const filterTitle = 'Filtrar eventos';
  static const filterCategory = 'Categoría';
  static const filterCity = 'Ciudad';
  static const filterDate = 'Fecha';
  static const applyFilters = 'Aplicar filtros';
  static const resetFilters = 'Resetear';
  static const clearFilters = 'Limpiar';
  static const clearFiltersAction = 'Limpiar filtros';

  // Quick Date Options
  static const dateToday = 'Hoy';
  static const dateThisWeek = 'Esta semana';
  static const dateThisWeekend = 'Este fin de semana';
  static const dateThisMonth = 'Este mes';
  static const selectDateRange = 'Seleccionar rango';

  // States
  static const noEventsTitle = 'Sin eventos';
  static const noEventsDescription =
      'No encontramos eventos con los filtros seleccionados.';
  static const errorTitle = 'Algo salió mal';
  static const retryAction = 'Reintentar';
  static const categoriesLoadError = 'No se pudieron cargar las categorias';
  static const citiesLoadError = 'No se pudieron cargar las ciudades';
  static const unexpectedError = 'Error inesperado al cargar los eventos.';

  // Event Detail
  static const totalPrice = 'Precio Total';
  static const free = 'Gratis';
  static const soldOut = 'Agotado';
  static const notAvailable = 'No disponible';
  static const bookNow = 'Reservar lugar';
  static const payNow = 'Pagar ahora';
  static const location = 'Ubicación';
  static const availability = 'Disponibilidad';
  static String remainingSpots(int count) =>
      count == 1 ? '1 lugar restante' : '$count lugares restantes';
  static const aboutEvent = 'Acerca del evento';
}
