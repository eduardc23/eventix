class BannersConfig {
  final AuthBannersConfig auth;
  final BookingBannersConfig booking;
  final ShellBannersConfig shell;

  BannersConfig({
    required this.auth,
    required this.booking,
    required this.shell,
  });

  factory BannersConfig.fromJson(Map<String, dynamic> json) {
    return BannersConfig(
      auth: AuthBannersConfig.fromJson(json['auth'] as Map<String, dynamic>),
      booking: BookingBannersConfig.fromJson(json['booking'] as Map<String, dynamic>),
      shell: ShellBannersConfig.fromJson(json['shell'] as Map<String, dynamic>),
    );
  }
}

class AuthBannersConfig {
  final String invalidCredentials;
  final String emailAlreadyInUse;
  final String tooManyRequests;
  final String unexpectedError;

  AuthBannersConfig({
    required this.invalidCredentials,
    required this.emailAlreadyInUse,
    required this.tooManyRequests,
    required this.unexpectedError,
  });

  factory AuthBannersConfig.fromJson(Map<String, dynamic> json) {
    return AuthBannersConfig(
      invalidCredentials: json['invalidCredentials'] as String,
      emailAlreadyInUse: json['emailAlreadyInUse'] as String,
      tooManyRequests: json['tooManyRequests'] as String,
      unexpectedError: json['unexpectedError'] as String,
    );
  }
}

class BookingBannersConfig {
  final String unexpectedError;

  BookingBannersConfig({
    required this.unexpectedError,
  });

  factory BookingBannersConfig.fromJson(Map<String, dynamic> json) {
    return BookingBannersConfig(
      unexpectedError: json['unexpectedError'] as String,
    );
  }
}

class ShellBannersConfig {
  final String signOutError;

  ShellBannersConfig({
    required this.signOutError,
  });

  factory ShellBannersConfig.fromJson(Map<String, dynamic> json) {
    return ShellBannersConfig(
      signOutError: json['signOutError'] as String,
    );
  }
}
