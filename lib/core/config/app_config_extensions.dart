import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';
import 'app_config_provider.dart';
import 'models/alerts_config.dart';
import 'models/app_info.dart';
import 'models/banners_config.dart';
import 'models/empty_messages_config.dart';
import 'models/sections_config.dart';
import 'models/ui_config.dart';
import 'models/welcome_texts_config.dart';

extension AppConfigX on WidgetRef {
  AppConfig get appConfig => read(appConfigProvider);

  // Accesos directos a las secciones
  AppInfo get appInfo => appConfig.app;
  UiConfig get uiConfig => appConfig.config.ui;
  SectionsConfig get sectionsConfig => appConfig.sections;
  WelcomeTextsConfig get welcomeTexts => appConfig.welcomeTexts;
  AlertsConfig get alertsConfig => appConfig.alerts;
  EmptyMessagesConfig get emptyMessages => appConfig.emptyMessages;
  BannersConfig get banners => appConfig.banners;
}
