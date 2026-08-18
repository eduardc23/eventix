class BookingStrings {
  BookingStrings._();

  // Page Titles
  static const bookingConfirmTitle = 'Confirmar Reserva';

  // Booking List
  static const upcomingSection = 'Próximas';
  static const pastSection = 'Anteriores';
  static const today = 'Hoy';
  static const tomorrow = 'Mañana';

  static String inDaysLabel(int days) => 'En $days días';

  static String ticketsCountVisualLabel(int count) => switch (count) {
        1 => '1 entrada',
        _ => '$count entradas',
      };

  // Loading State
  static const processingTransaction = 'Procesando transacción';
  static const loadingBookings = 'Cargando reservas';
  static const processingBooking = 'Procesando reserva';

  // Order Summary
  static const orderSummaryTitle = 'Resumen del pedido';

  static String quantityLabel(int quantity) => '$quantity x Entrada general';
  static const totalToPay = 'Total a pagar';

  // Quantity Selector
  static const quantityTitle = 'Cantidad';
  static const selectQuantity = 'Selecciona la cantidad de entradas';

  // Payment Methods
  static const paymentMethodTitle = 'Método de pago';
  static const mockCreditCard = 'Tarjeta de Crédito';
  static const mockCardNumber = '**** **** **** 4242';

  // Actions
  static const confirmBooking = 'Confirmar Reserva';
  static const payNow = 'Pagar Ahora';
  static const ok = 'Entendido';

  // Error Messages
  static const errorTitle = 'Error al cargar reservas';
  static const retryAction = 'Reintentar';

  // Accessibility
  static String ticketsCountLabel(int count) => switch (count) {
        1 => 'una entrada',
        _ => '$count entradas',
      };

  static String _bookingCountLabel(int count) => switch (count) {
        1 => 'una reserva',
        _ => '$count reservas',
      };

  static String sectionHeaderSemanticLabel(String label, int count) =>
      '$label, ${_bookingCountLabel(count)}';

  static String orderSummarySemanticLabel({
    required String title,
    required int quantity,
    required String formattedPrice,
  }) {
    return '$orderSummaryTitle. '
        '$title, '
        '${ticketsCountLabel(quantity)}, '
        '$totalToPay: $formattedPrice';
  }

  static String quantitySemanticLabel(int quantity) =>
      'Cantidad de entradas: $quantity';

  static const decreaseQuantitySemanticLabel = 'Disminuir cantidad';
  static const increaseQuantitySemanticLabel = 'Aumentar cantidad';

  static const paymentMethodSemanticLabel =
      'Tarjeta de crédito, tarjeta terminada en 4242';

  static const bookingListSemanticLabel = 'Lista de reservas';
}
