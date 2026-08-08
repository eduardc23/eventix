import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config_extensions.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../auth/presentation/providers/sign_out_provider.dart';
import '../constants/main_shell_strings.dart';
import 'widgets/app_drawer.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(signOutProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (error is AppFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText(
                  MainShellStrings.signOutError,
                  variant: AppTextVariant.bodyMedium,
                ),
              ),
            );
          }
        },
      );
    });

    return AppScaffold(
      drawer: AppDrawer(
        onSignOut: () {
          ref.read(signOutProvider.notifier).signOut();
        },
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const AppIcon(Icons.event_outlined),
            selectedIcon: const AppIcon(Icons.event),
            label: ref.sectionsConfig.events,
          ),
          NavigationDestination(
            icon: const AppIcon(Icons.confirmation_number_outlined),
            selectedIcon: const AppIcon(Icons.confirmation_number),
            label: ref.sectionsConfig.myBookings,
          ),
        ],
      ),
    );
  }
}
