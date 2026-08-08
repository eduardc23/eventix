class WelcomeTextsConfig {
  final AuthTextConfig login;
  final AuthTextConfig register;

  WelcomeTextsConfig({
    required this.login,
    required this.register,
  });

  factory WelcomeTextsConfig.fromJson(Map<String, dynamic> json) {
    return WelcomeTextsConfig(
      login: AuthTextConfig.fromJson(json['login'] as Map<String, dynamic>),
      register: AuthTextConfig.fromJson(json['register'] as Map<String, dynamic>),
    );
  }
}

class AuthTextConfig {
  final String subtitle;

  AuthTextConfig({
    required this.subtitle,
  });

  factory AuthTextConfig.fromJson(Map<String, dynamic> json) {
    return AuthTextConfig(
      subtitle: json['subtitle'] as String,
    );
  }
}
