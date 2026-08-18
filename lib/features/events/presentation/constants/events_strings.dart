class EventsStrings {
  EventsStrings._();

  // Page Titles
  static const eventsTitle = 'Eventos';
  static const eventDetailTitle = 'Detalle del Evento';

  // Filters
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
  static const errorTitle = 'Algo salió mal';
  static const retryAction = 'Reintentar';
  static const categoriesLoadError = 'No se pudieron cargar las categorias';
  static const citiesLoadError = 'No se pudieron cargar las ciudades';
  static const unexpectedError = 'Error inesperado al cargar los eventos.';
  static const loadingEvents = 'Cargando eventos';
  static const loadingFilters = 'Cargando filtros';

  // Event Detail
  static const totalPrice = 'Precio Total';
  static const soldOut = 'Agotado';
  static const notAvailable = 'No disponible';
  static const bookNow = 'Reservar lugar';
  static const payNow = 'Pagar ahora';
  static const location = 'Ubicación';
  static const availability = 'Disponibilidad';
  static const aboutEvent = 'Acerca del evento';

  static String remainingSpots(int count) =>
      count == 1 ? '1 lugar restante' : '$count lugares restantes';

  // Accessibility
  static const filterIconSemanticLabel = 'Filtrar eventos';
  static const eventListSemanticLabel = 'Lista de eventos';

  static String totalPriceSemanticLabel(String price) => '$totalPrice: $price';

  static String dateTimeSemanticLabel(String date, String time) =>
      'Fecha: $date a las $time';

  static String locationSemanticLabel(String city) => 'Ubicación: $city';

  static String capacitySemanticLabel(int spots) =>
      '$availability: ${remainingSpots(spots)}';

  static String eventImageSemanticLabel(String title) => 'Imagen evento $title';
}
