abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  // Shell y tabs base
  static const shell = '/home';

  // Segmentos relativos — dentro del shell
  static const eventsPath = 'events';
  static const bookingsPath = 'bookings';

  // Segmentos relativos — fuera del shell
  static const eventDetailPath = 'detail';
  static const eventBookingPath = 'booking';

  // Rutas completas dentro del shell
  static const events = '$shell/$eventsPath';
  static const bookings = '$shell/$bookingsPath';

  // Rutas completas fuera del shell (nivel raíz)
  static const eventDetail = '/detail';
  static const eventBooking = '/detail/$eventBookingPath';
}