import 'app_routes.dart';

// Lógica de redirección


/// Resultado de la evaluación de redirección.
///
/// Devuelve la ruta destino como [String], o `null` cuando no corresponde
/// redirigir (dejar continuar la navegación tal como está).
///
/// ### Parámetros
/// - [isLoading] — `true` mientras el estado de autenticación no se conoce.
/// - [hasError]  — `true` si el stream de auth emitió un error.
/// - [isAuthenticated] — `true` si existe un usuario autenticado.
/// - [location]  — ruta actualmente coincidente (p. ej. `/login`).
///
/// ### Reglas (en orden de precedencia)
/// 1. Auth cargando o con error → [AppRoutes.splash]
/// 2. No autenticado y fuera de rutas de auth → [AppRoutes.login]
/// 3. Autenticado y en splash / rutas de auth → [AppRoutes.events]
/// 4. Cualquier otro caso → `null` (sin redirección)
String? resolveAuthRedirect({
  required bool isLoading,
  required bool hasError,
  required bool isAuthenticated,
  required String location,
}) {
  if (isLoading || hasError) return AppRoutes.splash;

  final isOnSplash = location == AppRoutes.splash;
  final isOnAuth =
      location == AppRoutes.login || location == AppRoutes.register;

  if (!isAuthenticated && !isOnAuth) return AppRoutes.login;

  if (isAuthenticated && (isOnAuth || isOnSplash)) return AppRoutes.events;

  return null;
}
