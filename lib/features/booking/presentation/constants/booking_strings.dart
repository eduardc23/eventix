class BookingStrings {
  BookingStrings._();

  // Page Titles
  static const bookingConfirmTitle = 'Confirmar Reserva';
  static const checkoutTitle = 'Checkout';
  static const bookingListTitle = 'Mis reservas';

  // Booking List
  static const upcomingSection = 'Próximas';
  static const pastSection = 'Anteriores';
  static const today = 'Hoy';
  static const tomorrow = 'Mañana';
  static String inDaysLabel(int days) => 'En $days días';
  static String ticketsCountLabel(int count) =>
      '$count ${count == 1 ? 'entrada' : 'entradas'}';

  // Empty State
  static const emptyStateTitle = 'Sin reservas aún';
  static const emptyStateMessage =
      'Explora eventos y reserva tu próxima experiencia.';

  // Loading State
  static const processingTransaction = 'Procesando transacción...';

  // Order Summary
  static const orderSummaryTitle = 'Resumen del pedido';
  static String quantityLabel(int quantity) => '$quantity x Entrada general';
  static const totalToPay = 'Total a pagar';
  static const freeLabel = 'Gratis';

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

  // Success Dialog
  static const bookingConfirmedTitle = '¡Reserva Confirmada!';
  static String bookingConfirmedMessage(String eventTitle) =>
      'Tu lugar para "$eventTitle" ha sido asegurado con éxito.';
  static String paymentProcessedMessage(int amount) =>
      'El pago por \$${amount.toString()} se procesó correctamente.';

  // Error Messages
  static const errorTitle = 'Error al cargar reservas';
  static const retryAction = 'Reintentar';
  static const noSpotsTitle = 'Sin cupos disponibles';
  static const noSpotsMessage = 'Lo sentimos, ya no quedan cupos para este evento.';
  static const unexpectedBookingError = 'Ocurrió un error inesperado al procesar tu reserva.';
}
