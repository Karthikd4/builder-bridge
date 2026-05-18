# Skill: go_router Navigation Patterns

Standard navigation patterns for BuilderBridge using go_router ^14.x.

## 1. Route Definitions

```dart
// lib/core/navigation/app_router.dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull?.isLoggedIn ?? false;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthShell(),
        routes: [
          GoRoute(path: 'login', builder: (_, __) => const LoginScreen()),
          GoRoute(path: 'otp', builder: (_, state) {
            final phone = state.extra as String;
            return OtpScreen(phone: phone);
          }),
        ],
      ),
      ShellRoute(
        builder: (_, __, child) => DashboardShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardHomeScreen()),
          GoRoute(path: '/inventory', builder: (_, __) => const InventoryScreen()),
          GoRoute(
            path: '/inventory/tower/:towerId',
            builder: (_, state) => TowerScreen(
              towerId: int.parse(state.pathParameters['towerId']!),
            ),
          ),
          GoRoute(
            path: '/inventory/unit/:unitId',
            builder: (_, state) => UnitDetailScreen(
              unitId: int.parse(state.pathParameters['unitId']!),
            ),
          ),
          GoRoute(path: '/payments', builder: (_, __) => const PaymentsScreen()),
          GoRoute(path: '/documents', builder: (_, __) => const DocumentsScreen()),
          GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
          GoRoute(path: '/support/new', builder: (_, __) => const CreateTicketScreen()),
        ],
      ),
    ],
  );
});
```

## 2. Navigation Calls

```dart
// Push (adds to stack)
context.push('/inventory/unit/${unit.id}');

// Go (replaces stack — use for tab navigation)
context.go('/dashboard');

// Push with extra object (non-serializable params)
context.push('/auth/otp', extra: phoneNumber);

// Replace (no back button)
context.pushReplacement('/dashboard');

// Pop with result
context.pop(true);
```

## 3. ShellRoute for Bottom Nav

```dart
// lib/features/dashboard/presentation/screens/dashboard_shell.dart
class DashboardShell extends StatelessWidget {
  final Widget child;
  const DashboardShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BBBottomNav(
        currentIndex: _indexFor(GoRouterState.of(context).matchedLocation),
        onTap: (i) => context.go(_routeFor(i)),
      ),
    );
  }

  int _indexFor(String location) {
    if (location.startsWith('/inventory')) return 1;
    if (location.startsWith('/payments')) return 2;
    if (location.startsWith('/documents')) return 3;
    if (location.startsWith('/support')) return 4;
    return 0;
  }

  String _routeFor(int index) =>
      ['/dashboard', '/inventory', '/payments', '/documents', '/support'][index];
}
```

## 4. Auth Redirect Guard

```dart
redirect: (context, state) {
  final isAuth = ref.read(authStateProvider).valueOrNull?.isAuthenticated ?? false;
  final goingToAuth = state.matchedLocation.startsWith('/auth');
  if (!isAuth && !goingToAuth) return '/auth/login';
  if (isAuth && goingToAuth) return '/dashboard';
  return null;  // No redirect
},
```

## Rules
- All routes defined in `app_router.dart` — no inline `MaterialPageRoute`
- Use path parameters for IDs, `extra` for complex objects
- Use `context.go()` for tab switches, `context.push()` for drill-down
- Auth guard via `redirect` — not scattered in screens
