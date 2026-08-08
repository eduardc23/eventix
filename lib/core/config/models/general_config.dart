import 'ui_config.dart';

class GeneralConfig {
  final UiConfig ui;

  GeneralConfig({required this.ui});

  factory GeneralConfig.fromJson(Map<String, dynamic> json) {
    return GeneralConfig(
      ui: UiConfig.fromJson(json['ui'] as Map<String, dynamic>),
    );
  }
}
