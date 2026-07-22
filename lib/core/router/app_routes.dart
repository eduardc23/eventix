abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  // Shell y tabs base
  static const shell = '/home';
  
  // Segmentos relativos (usados en la definición de sub-rutas de GoRouter)
  static const eventsPath = 'events';
  static const bookingsPath = 'bookings';
  static const eventDetailPath = 'detail';
  static const eventBookingPath = 'booking';

  // Rutas completas (usadas para navegación: context.go, context.push)
  static const events = '$shell/$eventsPath';
  static const bookings = '$shell/$bookingsPath';
  
  static const eventDetail = '$events/$eventDetailPath';
  static const eventBooking = '$eventDetail/$eventBookingPath';
}
