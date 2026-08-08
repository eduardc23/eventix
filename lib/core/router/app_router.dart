import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth.dart';
import '../../features/booking/booking.dart';
import '../../features/events/events.dart';
import '../../features/shell/shell.dart';
import '../../features/splash/splash.dart';
import '../di/core_di_providers.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

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
    refreshListenable: StreamToListenable(
      ref.watch(firebaseAuthProvider).authStateChanges(),
    ),

    /// Lógica de redirección global.
    ///
    /// Se ejecuta antes de cada navegación y aplica las siguientes reglas:
    /// - Si auth está cargando o tiene error → [AppRoutes.splash]
    /// - Si no está autenticado y no está en una ruta de auth → [AppRoutes.login]
    /// - Si está autenticado y está en splash o auth → [AppRoutes.events]
    /// - En cualquier otro caso → sin redirección (retorna null)
    redirect: (context, state) => resolveAuthRedirect(
      isLoading: authState.isLoading,
      hasError: authState.hasError,
      isAuthenticated: authState.value != null,
      location: state.matchedLocation,
    ),
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
@visibleForTesting
class StreamToListenable extends ChangeNotifier {
  StreamToListenable(Stream<User?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
