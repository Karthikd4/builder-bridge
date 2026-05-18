import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;
  const DashboardShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentSoft,
        selectedIndex: _indexFor(location),
        onDestinationSelected: (i) => context.go(_routeFor(i)),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.apartment_outlined),
              selectedIcon: Icon(Icons.apartment), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.payments_outlined),
              selectedIcon: Icon(Icons.payments), label: 'Payments'),
          NavigationDestination(icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder), label: 'Documents'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined),
              selectedIcon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }

  int _indexFor(String location) => switch (true) {
        _ when location.startsWith(AppRoutes.inventory) => 1,
        _ when location.startsWith(AppRoutes.payments)  => 2,
        _ when location.startsWith(AppRoutes.documents) => 3,
        _ when location.startsWith(AppRoutes.support)   => 4,
        _ => 0,
      };

  String _routeFor(int i) => [
        AppRoutes.dashboard,
        AppRoutes.inventory,
        AppRoutes.payments,
        AppRoutes.documents,
        AppRoutes.support,
      ][i];
}
