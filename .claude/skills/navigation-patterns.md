# Skill: Navigation Patterns

go_router navigation patterns for BuilderBridge. See also: `go-router-patterns.md`.

## Route Map

```
/splash                       → SplashScreen
/auth/login                   → LoginScreen
/auth/otp                     → OtpScreen (extra: phone)
/dashboard                    → DashboardHomeScreen [shell]
/inventory                    → InventoryScreen [shell]
/inventory/tower/:towerId     → TowerScreen
/inventory/unit/:unitId       → UnitDetailScreen
/booking/:unitId              → BookingSummaryScreen
/payments                     → PaymentsScreen [shell]
/payments/milestone/:id       → MilestoneDetailScreen
/payments/receipt/:id         → ReceiptScreen
/documents                    → DocumentsScreen [shell]
/documents/:id                → DocumentDetailScreen
/support                      → SupportScreen [shell]
/support/new                  → CreateTicketScreen
/support/:id                  → TicketDetailScreen
/settings                     → SettingsScreen
```

`[shell]` = rendered inside DashboardShell with bottom nav.

## Navigation Decision Tree

```
Is it a tab-level screen?        → context.go('/route')
Is it a drill-down from list?    → context.push('/route/id')
Is it a modal/form?              → context.push('/route')
After form submit success?       → context.pop() or context.go('/parent')
After logout?                    → context.go('/auth/login')
```

## Type-Safe Parameter Passing

```dart
// Simple IDs: use path parameters
context.push('/inventory/unit/$unitId');

// Complex objects: use extra (not persisted across app restarts)
context.push('/auth/otp', extra: phoneNumber);

// Receiving extra:
GoRoute(
  path: '/auth/otp',
  builder: (context, state) {
    final phone = state.extra as String;
    return OtpScreen(phone: phone);
  },
),
```

## Back Navigation with Confirmation

```dart
// For forms with unsaved changes
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, _) async {
    if (didPop) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep editing')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) context.pop();
  },
  child: ...,
)
```

## Deep Link Handling

```dart
// go_router handles deep links automatically if routes match
// Ensure auth guard redirects unauthenticated deep links to login
// then redirects back to original route after auth

redirect: (context, state) {
  if (!isAuthenticated && !state.matchedLocation.startsWith('/auth')) {
    return '/auth/login?redirect=${state.uri}';
  }
  return null;
},
```

## Bottom Nav Highlight

```dart
int _currentIndex(String location) {
  return switch (true) {
    _ when location.startsWith('/inventory') => 1,
    _ when location.startsWith('/payments')  => 2,
    _ when location.startsWith('/documents') => 3,
    _ when location.startsWith('/support')   => 4,
    _ => 0, // dashboard
  };
}
```
