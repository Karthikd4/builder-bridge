import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_interests_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/customer_onboarding_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/unit_availability_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _destinations = [
    (icon: Icons.dashboard_outlined,  activeIcon: Icons.dashboard_rounded,   label: 'Dashboard'),
    (icon: Icons.person_add_outlined,  activeIcon: Icons.person_add_rounded,  label: 'Onboard'),
    (icon: Icons.star_border_rounded,  activeIcon: Icons.star_rounded,        label: 'Interests'),
    (icon: Icons.apartment_outlined,   activeIcon: Icons.apartment_rounded,   label: 'Units'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.surface,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Icon(Icons.corporate_fare_rounded,
                      color: AppColors.accent, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    'Admin',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            destinations: _destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.activeIcon),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1, color: AppColors.line),
          Expanded(child: _activePage),
        ],
      ),
    );
  }

  Widget get _activePage => switch (_selectedIndex) {
        0 => const AdminDashboardScreen(),
        1 => const CustomerOnboardingScreen(),
        2 => const AdminInterestsScreen(),
        3 => const UnitAvailabilityScreen(),
        _ => const SizedBox.shrink(),
      };
}
