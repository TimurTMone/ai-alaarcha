import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/l10n_extension.dart';
import 'core/constants/app_colors.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/accommodations')) return 0;
    if (location.startsWith('/trails')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/trails');
            case 2:
              context.go('/profile');
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: context.l10n.explore,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}
