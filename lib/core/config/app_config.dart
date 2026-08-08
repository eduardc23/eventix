import 'models/alerts_config.dart';
import 'models/app_info.dart';
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

  AppConfig({
    required this.app,
    required this.config,
    required this.sections,
    required this.welcomeTexts,
    required this.alerts,
    required this.emptyMessages,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      app: AppInfo.fromJson(json['app'] as Map<String, dynamic>),
      config: GeneralConfig.fromJson(json['config'] as Map<String, dynamic>),
      sections: SectionsConfig.fromJson(json['sections'] as Map<String, dynamic>),
      welcomeTexts: WelcomeTextsConfig.fromJson(json['welcomeTexts'] as Map<String, dynamic>),
      alerts: AlertsConfig.fromJson(json['alerts'] as Map<String, dynamic>),
      emptyMessages: EmptyMessagesConfig.fromJson(json['emptyMessages'] as Map<String, dynamic>),
    );
  }
}
