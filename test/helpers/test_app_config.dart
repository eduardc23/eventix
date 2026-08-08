import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/models/alerts_config.dart';
import 'package:eventix/core/config/models/app_info.dart';
import 'package:eventix/core/config/models/empty_messages_config.dart';
import 'package:eventix/core/config/models/general_config.dart';
import 'package:eventix/core/config/models/sections_config.dart';
import 'package:eventix/core/config/models/ui_config.dart';
import 'package:eventix/core/config/models/welcome_texts_config.dart';

final testAppConfig = AppConfig(
  app: AppInfo(name: 'Eventix Test'),
  config: GeneralConfig(
    ui: UiConfig(
      filtersInitialSize: 0.5,
      filtersMinSize: 0.2,
      filtersMaxSize: 0.9,
      dateRangeMaxDays: 30,
    ),
  ),
  sections: SectionsConfig(
    events: 'Events',
    eventDetail: 'Event Detail',
    myBookings: 'My Bookings',
    checkout: 'Checkout',
    filters: 'Filters',
    bookingConfirm: 'Booking Confirm',
  ),
  welcomeTexts: WelcomeTextsConfig(
    login: AuthTextConfig(subtitle: 'Login Subtitle'),
    register: AuthTextConfig(subtitle: 'Register Subtitle'),
  ),
  alerts: AlertsConfig(
    bookingSuccess: AlertDetailConfig(title: 'Success', message: 'Booking successful'),
    noSpots: AlertDetailConfig(title: 'No Spots', message: 'No spots available'),
    paymentProcessed: 'Payment processed correctly',
  ),
  emptyMessages: EmptyMessagesConfig(
    events: EmptyMessageDetailConfig(title: 'No Events', description: 'No events found'),
    bookings: EmptyMessageDetailConfig(title: 'No Bookings', description: 'No bookings found'),
  ),
);
