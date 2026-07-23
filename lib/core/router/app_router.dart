import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth.dart';
import '../../features/booking/booking.dart';
import '../../features/events/events.dart';
import '../../features/shell/shell.dart';
import '../../features/splash/splash.dart';
import '../di/core_di_providers.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

/// Proveedor del router principal de la aplicación.
///
/// Observa el estado de autenticación de Firebase y redirige automáticamente
/// según si el usuario está autenticado o no. El router se refresca en cada
/// cambio del stream de autenticación gracias a [_StreamToListenable].
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _StreamToListenable(
      ref.watch(firebaseAuthProvider).authStateChanges(),
    ),

    /// Lógica de redirección global.
    ///
    /// Se ejecuta antes de cada navegación y aplica las siguientes reglas:
    /// - Si auth está cargando o tiene error → [AppRoutes.splash]
    /// - Si no está autenticado y no está en una ruta de auth → [AppRoutes.login]
    /// - Si está autenticado y está en splash o auth → [AppRoutes.events]
    /// - En cualquier otro caso → sin redirección (retorna null)
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) {
        return AppRoutes.splash;
      }

      final isAuthenticated = authState.value != null;
      final location = state.matchedLocation;

      final isOnSplash = location == AppRoutes.splash;
      final isOnAuth =
          location == AppRoutes.login || location == AppRoutes.register;

      if (!isAuthenticated && !isOnAuth) return AppRoutes.login;

      // Al autenticarse, mandamos al tab inicial
      if (isAuthenticated && (isOnAuth || isOnSplash)) {
        return AppRoutes.events;
      }

      return null;
    },
    routes: [
      /// Pantalla de splash. Punto de entrada inicial mientras se resuelve
      /// el estado de autenticación.
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      /// Pantalla de inicio de sesión.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      /// Pantalla de registro de nuevo usuario.
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      /// Shell con navegación por tabs. Mantiene el estado de cada rama
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.events,
                builder: (_, _) => const EventListPage(),
                // Sin rutas anidadas aquí
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookings,
                builder: (_, _) => const BookingListPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.eventDetail,
        builder: (_, state) {
          final event = state.extra as EventEntity;
          return EventDetailPage(event: event);
        },
        routes: [
          GoRoute(
            path: AppRoutes.eventBookingPath,
            builder: (_, state) {
              final event = state.extra as EventEntity;
              return BookingPage(event: event);
            },
          ),
        ],
      ),
    ],
  );
}

/// Adapta un Stream a Listenable para que GoRouter se refresque
/// automáticamente cuando cambia el estado de autenticación.
class _StreamToListenable extends ChangeNotifier {
  _StreamToListenable(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
