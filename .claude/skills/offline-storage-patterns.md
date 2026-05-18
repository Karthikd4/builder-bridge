# Skill: Offline Storage Patterns

Patterns for BuilderBridge offline-first data layer. Phase 1: SQLite only. Phase 2: sync layer added.

## Storage Decision Matrix

| Data Type | Storage | Reason |
|---|---|---|
| Domain data (units, payments, tickets) | SQLite via sqflite | Structured, queryable |
| Auth session / user ID | SQLite `sessions` table | Consistent with domain data |
| UI preferences (theme, last tab) | shared_preferences | Lightweight, no schema |
| Downloaded documents | `getApplicationDocumentsDirectory()` | Private, not backed up |
| Pending sync queue (Phase 2) | SQLite `pending_sync` table | Survives app restart |

## 1. First-Launch Seed

```dart
// lib/core/database/seed_loader.dart
class SeedLoader {
  final Database db;
  SeedLoader(this.db);

  Future<void> loadIfEmpty() async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM projects'),
    ) ?? 0;
    if (count > 0) return;

    final jsonStr = await rootBundle.loadString('assets/seed/seed_data.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    await _insertAll(data);
  }

  Future<void> _insertAll(Map<String, dynamic> data) async {
    final batch = db.batch();
    for (final project in data['projects'] as List) {
      batch.insert('projects', project as Map<String, dynamic>);
    }
    for (final tower in data['towers'] as List) {
      batch.insert('towers', tower as Map<String, dynamic>);
    }
    // ... repeat for all tables
    await batch.commit(noResult: true);
  }
}
```

## 2. Abstract Repository Interface (Phase 2 readiness)

```dart
// features/inventory/data/repositories/i_inventory_repository.dart
abstract interface class IInventoryRepository {
  Future<List<Unit>> getUnits(int towerId, {UnitStatus? status});
  Future<Unit?> getUnit(int id);
  Future<List<Project>> getProjects();
}

// Phase 1 implementation
class LocalInventoryRepository implements IInventoryRepository { ... }

// Phase 2: swap to this
class RemoteInventoryRepository implements IInventoryRepository { ... }
```

Register via provider:
```dart
final inventoryRepositoryProvider = Provider<IInventoryRepository>((ref) {
  return LocalInventoryRepository(ref.read(databaseProvider));
  // Phase 2: return RemoteInventoryRepository(ref.read(httpClientProvider));
});
```

## 3. Pending Sync Schema (add now, use in Phase 2)

```sql
CREATE TABLE pending_sync (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL,
  entity_id INTEGER,
  operation TEXT NOT NULL,
  payload TEXT NOT NULL,
  created_at TEXT NOT NULL,
  synced_at TEXT
);
```

```dart
// Queue a write for Phase 2 sync
Future<void> queueSync({
  required String entityType,
  required String operation,
  required Map<String, dynamic> payload,
}) async {
  final db = await _db.database;
  await db.insert('pending_sync', {
    'entity_type': entityType,
    'operation': operation,
    'payload': jsonEncode(payload),
    'created_at': DateTime.now().toIso8601String(),
  });
}
```

## 4. Date Storage Convention

```dart
// Always store as ISO 8601 string
extension DateStorage on DateTime {
  String toDbString() => toIso8601String();
}

extension DateParsing on String {
  DateTime toDateTime() => DateTime.parse(this);
}

// In model fromMap:
dueDate: DateTime.parse(map['due_date'] as String),
// In toMap:
'due_date': dueDate.toIso8601String(),
```

## 5. Currency Storage Convention
```dart
// Store as INTEGER (smallest unit — paise for INR, cents for USD)
// Never use REAL/double for money

// Display helper
String formatAmount(int paise) {
  final rupees = paise / 100;
  return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(rupees);
}
```
