# Skill: Flutter Feature Architecture

Use feature-first architecture for all BuilderBridge feature modules.

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── database/
│   │   ├── database_helper.dart
│   │   └── migrations/
│   ├── navigation/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   └── widgets/
│       ├── bb_button.dart
│       ├── bb_card.dart
│       ├── bb_badge.dart
│       ├── bb_loading_state.dart
│       ├── bb_empty_state.dart
│       ├── bb_error_state.dart
│       └── bb_app_bar.dart
├── shared/
│   ├── exceptions/
│   └── extensions/
└── features/
    ├── auth/
    ├── dashboard/
    ├── inventory/
    ├── booking/
    ├── payments/
    ├── documents/
    └── support/
```

## Feature Structure (repeat for every feature)

```
features/<name>/
├── data/
│   ├── models/
│   │   └── <name>_model.dart          ← freezed data class
│   └── repositories/
│       └── <name>_repository.dart     ← SQLite queries
└── presentation/
    ├── screens/
    │   └── <name>_screen.dart         ← ConsumerWidget
    ├── widgets/
    │   └── <name>_card.dart           ← Sub-widgets
    └── providers/
        └── <name>_provider.dart       ← Riverpod notifier
```

## File Creation Order (for each new feature)

1. `data/models/<name>_model.dart` — freezed class
2. `data/repositories/<name>_repository.dart` — CRUD methods
3. `presentation/providers/<name>_provider.dart` — Riverpod notifier
4. `presentation/widgets/*.dart` — reusable sub-widgets
5. `presentation/screens/<name>_screen.dart` — screen assembly
6. Register route in `core/navigation/app_router.dart`

## Cross-Feature Import Rules

```dart
// ALLOWED
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/features/auth/data/models/user_model.dart';

// FORBIDDEN (feature reaching into another feature's internals)
import 'package:builder_bridge/features/payments/data/repositories/payment_repository.dart';
// ↑ Access via provider injection, not direct import
```

## Screen Size Rule
- Screen files: ≤ 200 lines
- Extract any section > 50 lines into a named widget
- Widget names describe content: `PaymentMilestoneCard`, not `Card1`
