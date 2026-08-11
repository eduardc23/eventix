import 'package:flutter/foundation.dart';

import '../data/exceptions/config_exceptions.dart';
import 'models/alerts_config.dart';
import 'models/app_info.dart';
import 'models/banners_config.dart';
import 'models/empty_messages_config.dart';
import 'models/general_config.dart';
import 'models/sections_config.dart';
import 'models/welcome_texts_config.dart';

class AppConfig {
  final AppInfo app;
  final GeneralConfig config;
  final SectionsConfig sections;
  final WelcomeTextsConfig welcomeTexts;
  final AlertsConfig alerts;
  final EmptyMessagesConfig emptyMessages;
  final BannersConfig banners;

  AppConfig({
    required this.app,
    required this.config,
    required this.sections,
    required this.welcomeTexts,
    required this.alerts,
    required this.emptyMessages,
    required this.banners,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      app: AppConfigParser.parseSection(json, 'app', AppInfo.fromJson),
      config: AppConfigParser.parseSection(json, 'config', GeneralConfig.fromJson),
      sections: AppConfigParser.parseSection(json, 'sections', SectionsConfig.fromJson),
      welcomeTexts: AppConfigParser.parseSection(json, 'welcomeTexts', WelcomeTextsConfig.fromJson),
      alerts: AppConfigParser.parseSection(json, 'alerts', AlertsConfig.fromJson),
      emptyMessages: AppConfigParser.parseSection(json, 'emptyMessages', EmptyMessagesConfig.fromJson),
      banners: AppConfigParser.parseSection(json, 'banners', BannersConfig.fromJson),
    );
  }
}


abstract final class AppConfigParser {
  static T parseSection<T>(
      Map<String, dynamic> json,
      String key,
      T Function(Map<String, dynamic>) parser,
      ) {
    final value = json[key];

    if (value == null) {
      debugPrint('[AppConfig] Sección "$key" no encontrada en app_config.json');
      throw ConfigSectionException(section: key);
    }

    if (value is! Map<String, dynamic>) {
      debugPrint('[AppConfig] Sección "$key" tiene un formato inválido en app_config.json');
      throw ConfigSectionException(section: key);
    }

    try {
      return parser(value);
    } catch (e) {
      debugPrint('[AppConfig] Error al parsear la sección "$key": $e');
      throw ConfigSectionException(section: key);
    }
  }
}