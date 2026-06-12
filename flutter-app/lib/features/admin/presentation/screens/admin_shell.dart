import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_customers_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_interests_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_team_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_tickets_screen.dart';
import 'package:builder_bridge/features/admin/presentation/screens/unit_availability_screen.dart';

class AdminShell extends StatefulWidget {
  final VoidCallback? onLogout;
  const AdminShell({this.onLogout, super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _destinations = [
    (icon: Icons.dashboard_outlined,  activeIcon: Icons.dashboard_rounded,   label: 'Dashboard'),
    (icon: Icons.star_border_rounded,  activeIcon: Icons.star_rounded,        label: 'Interests'),
    (icon: Icons.apartment_outlined,   activeIcon: Icons.apartment_rounded,   label: 'Units'),
    (icon: Icons.people_outlined,      activeIcon: Icons.people_rounded,      label: 'Customers'),
    (icon: Icons.confirmation_number_outlined, activeIcon: Icons.confirmation_number_rounded, label: 'Tickets'),
    (icon: Icons.group_outlined,       activeIcon: Icons.group_rounded,       label: 'Team'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _BrandHeader(),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.surface,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (i) =>
                      setState(() => _selectedIndex = i),
                  labelType: NavigationRailLabelType.all,
                  leading: const SizedBox(height: AppSpacing.sm),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IconButton(
                          tooltip: 'Logout',
                          icon: const Icon(Icons.logout_rounded,
                              color: AppColors.inkMute),
                          onPressed: widget.onLogout,
                        ),
                      ),
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
          ),
          const _BrandFooter(),
        ],
      ),
    );
  }

  Widget get _activePage => switch (_selectedIndex) {
        0 => const AdminDashboardScreen(),
        1 => const AdminInterestsScreen(),
        2 => const UnitAvailabilityScreen(),
        3 => const AdminCustomersScreen(),
        4 => const AdminTicketsScreen(),
        5 => const AdminTeamScreen(),
        _ => const SizedBox.shrink(),
      };
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Image.asset(
              'assets/images/vue_logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('The Vue Residences',
              style: AppTypography.headlineSmall),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text('Admin',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.accent)),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/bb_mark.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('BuilderBridge',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.inkMute)),
        ],
      ),
    );
  }
}

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: AppColors.surfaceMute,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Text(
            'Raghuram Pradeep Constructions (India) LLP',
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.inkFaint, fontSize: 10),
          ),
          const Spacer(),
          Text(
            'Powered by BuilderBridge',
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.inkFaint, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
