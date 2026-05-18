# Skill: Riverpod Patterns

Standard Riverpod patterns for BuilderBridge. Use these templates, don't invent new patterns.

## 1. Repository Provider

```dart
// features/inventory/data/repositories/inventory_repository.dart
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepository(db);
});
```

## 2. Async List Notifier

```dart
// features/inventory/presentation/providers/units_provider.dart
@riverpod
class UnitsNotifier extends _$UnitsNotifier {
  @override
  Future<List<Unit>> build(int towerId) async {
    return ref.read(inventoryRepositoryProvider).getUnits(towerId);
  }

  Future<void> refresh(int towerId) async {
    ref.invalidateSelf();
  }
}
```

## 3. Form State Notifier

```dart
@riverpod
class CreateTicketNotifier extends _$CreateTicketNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit(CreateTicketRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(supportRepositoryProvider).createTicket(request),
    );
  }
}
```

## 4. Widget Consumption

```dart
class UnitListScreen extends ConsumerWidget {
  final int towerId;
  const UnitListScreen({required this.towerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(unitsNotifierProvider(towerId));

    return unitsAsync.when(
      data: (units) => units.isEmpty
          ? const BBEmptyState(message: 'No units available')
          : UnitGrid(units: units),
      loading: () => const BBLoadingState(),
      error: (e, _) => BBErrorState(
        message: 'Could not load units',
        onRetry: () => ref.refresh(unitsNotifierProvider(towerId)),
      ),
    );
  }
}
```

## 5. Optimized Rebuild with select()

```dart
// Only rebuilds when openTicketCount changes
final count = ref.watch(
  ticketsNotifierProvider.select((async) => async.valueOrNull?.openCount ?? 0),
);
```

## 6. Auth-Scoped Providers

```dart
// Invalidate all feature providers on logout
void logout(WidgetRef ref) {
  ref.invalidate(unitsNotifierProvider);
  ref.invalidate(bookingNotifierProvider);
  ref.invalidate(paymentsNotifierProvider);
  ref.invalidate(currentUserProvider);
}
```

## 7. Family Provider (parameterized)

```dart
// Passing unit ID as parameter
@riverpod
Future<Unit> unitDetail(Ref ref, int unitId) {
  return ref.read(inventoryRepositoryProvider).getUnit(unitId);
}

// Usage
final unit = ref.watch(unitDetailProvider(widget.unitId));
```

## Anti-Patterns — Never Do

```dart
// WRONG: setState for business state
setState(() { _units = await repo.getUnits(); });

// WRONG: BuildContext in provider
class MyNotifier extends Notifier {
  void doSomething(BuildContext context) { ... } // No!
}

// WRONG: ref.read in build()
Widget build(BuildContext context, WidgetRef ref) {
  final units = ref.read(unitsProvider); // Use watch!
}
```
