import 'package:eventix/core/router/app_routes.dart';
import 'package:eventix/core/router/auth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wrapper con valores por defecto para reducir ruido en cada test.
/// Solo se sobreescriben los parámetros relevantes para el caso en cuestión.
String? resolve({
  bool isLoading = false,
  bool hasError = false,
  bool isAuthenticated = false,
  String location = AppRoutes.splash,
}) => resolveAuthRedirect(
  isLoading: isLoading,
  hasError: hasError,
  isAuthenticated: isAuthenticated,
  location: location,
);

void main() {
  group('AuthRedirect - Regla 1: Carga y Error', () {
    test('debe redirigir a splash si está cargando', () {
      final result = resolve(isLoading: true, location: AppRoutes.events);
      expect(result, equals(AppRoutes.splash));
    });

    test('debe redirigir a splash si hay un error en auth', () {
      final result = resolve(hasError: true, location: AppRoutes.login);
      expect(result, equals(AppRoutes.splash));
    });
  });

  group('AuthRedirect - Regla 2: No Autenticado', () {
    test('debe redirigir a login si NO está autenticado y va a una ruta protegida', () {
      final result = resolve(
        isAuthenticated: false,
        location: AppRoutes.events,
      );
      expect(result, equals(AppRoutes.login));
    });

    test('NO debe redirigir (retorna null) si NO está autenticado y ya va a login o register', () {
      final toLogin = resolve(isAuthenticated: false, location: AppRoutes.login);
      final toRegister = resolve(isAuthenticated: false, location: AppRoutes.register);
      
      expect(toLogin, isNull);
      expect(toRegister, isNull);
    });
  });

  group('AuthRedirect - Regla 3: Autenticado', () {
    test('debe redirigir a events si está autenticado y trata de ir a login, register o splash', () {
      final fromLogin = resolve(isAuthenticated: true, location: AppRoutes.login);
      final fromRegister = resolve(isAuthenticated: true, location: AppRoutes.register);
      final fromSplash = resolve(isAuthenticated: true, location: AppRoutes.splash);
      
      expect(fromLogin, equals(AppRoutes.events));
      expect(fromRegister, equals(AppRoutes.events));
      expect(fromSplash, equals(AppRoutes.events));
    });
  });

  group('AuthRedirect - Regla 4: Flujo Normal', () {
    test('NO debe redirigir (retorna null) si está autenticado navegando a rutas protegidas', () {
      final result = resolve(
        isAuthenticated: true,
        location: AppRoutes.bookings,
      );
      
      expect(result, isNull);
    });
  });
}
