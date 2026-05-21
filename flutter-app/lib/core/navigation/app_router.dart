import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/auth/presentation/screens/auth_success_screen.dart';
import 'package:builder_bridge/features/auth/presentation/screens/login_screen.dart';
import 'package:builder_bridge/features/auth/presentation/screens/otp_screen.dart';
import 'package:builder_bridge/features/auth/presentation/screens/splash_screen.dart';
import 'package:builder_bridge/features/dashboard/presentation/screens/dashboard_home_screen.dart';
import 'package:builder_bridge/features/dashboard/presentation/screens/dashboard_shell.dart';
import 'package:builder_bridge/features/documents/presentation/screens/documents_screen.dart';
import 'package:builder_bridge/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:builder_bridge/features/inventory/presentation/screens/tower_floor_screen.dart';
import 'package:builder_bridge/features/payments/presentation/screens/payments_screen.dart';
import 'package:builder_bridge/features/booking/presentation/screens/booking_confirm_screen.dart';
import 'package:builder_bridge/features/booking/presentation/screens/estimate_screen.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/support/presentation/screens/create_ticket_screen.dart';
import 'package:builder_bridge/features/support/presentation/screens/support_screen.dart';
import 'package:builder_bridge/features/support/presentation/screens/ticket_detail_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuthenticated;
      final isLoading = notifier.isLoading;
      final loc = state.uri.path;

      if (isLoading) return null;

      final onAuth = loc.startsWith('/auth') || loc == AppRoutes.splash;
      if (!isAuth && !onAuth) return AppRoutes.login;
      if (isAuth && onAuth && loc != AppRoutes.authSuccess) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) => OtpScreen(phone: state.extra as String),
      ),
      GoRoute(
        path: AppRoutes.authSuccess,
        builder: (_, __) => const AuthSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.estimate,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EstimateScreen(
            unit: extra['unit'] as UnitModel,
            towerName: extra['towerName'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.bookingConfirm,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookingConfirmScreen(
            unit: extra['unit'] as UnitModel,
            towerName: extra['towerName'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.supportNew,
        builder: (_, __) => const CreateTicketScreen(),
      ),
      GoRoute(
        path: '/support/:id',
        builder: (_, state) => TicketDetailScreen(
          ticketId: int.parse(state.pathParameters['id']!),
        ),
      ),
      ShellRoute(
        builder: (_, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (_, __) => const DashboardHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            builder: (_, __) => const InventoryScreen(),
            routes: [
              GoRoute(
                path: 'tower/:towerId',
                builder: (_, state) => TowerFloorScreen(
                  towerId: int.parse(state.pathParameters['towerId']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.payments,
            builder: (_, __) => const PaymentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.documents,
            builder: (_, __) => const DocumentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.support,
            builder: (_, __) => const SupportScreen(),
          ),
        ],
      ),
    ],
  );
}
