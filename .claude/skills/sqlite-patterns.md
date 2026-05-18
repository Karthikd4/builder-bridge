# Skill: SQLite Patterns (sqflite)

Standard SQLite patterns for BuilderBridge. All DB access through repositories only.

## 1. DatabaseHelper Singleton

```dart
// lib/core/database/database_helper.dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'builderbridge.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(MigrationV1.createTables);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) await db.execute(MigrationV2.addPendingSync);
  }
}
```

## 2. Migration Files

```dart
// lib/core/database/migrations/migration_v1.dart
class MigrationV1 {
  static const createTables = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT NOT NULL UNIQUE,
      name TEXT,
      email TEXT,
      created_at TEXT NOT NULL
    );
    CREATE TABLE units (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tower_id INTEGER NOT NULL,
      floor INTEGER NOT NULL,
      unit_no TEXT NOT NULL,
      type TEXT NOT NULL,
      area_sqft REAL NOT NULL,
      status TEXT NOT NULL DEFAULT 'available',
      base_price INTEGER NOT NULL,
      FOREIGN KEY (tower_id) REFERENCES towers(id)
    );
  ''';
}
```

## 3. Repository Pattern

```dart
// features/inventory/data/repositories/inventory_repository.dart
class InventoryRepository {
  final DatabaseHelper _db;
  InventoryRepository(this._db);

  Future<List<Unit>> getUnits(int towerId, {UnitStatus? status}) async {
    final db = await _db.database;
    final where = status != null
        ? 'tower_id = ? AND status = ?'
        : 'tower_id = ?';
    final args = status != null
        ? [towerId, status.name]
        : [towerId];

    final maps = await db.query('units', where: where, whereArgs: args);
    return maps.map(Unit.fromMap).toList();
  }

  Future<Unit?> getUnit(int id) async {
    final db = await _db.database;
    final maps = await db.query('units', where: 'id = ?', whereArgs: [id]);
    return maps.isEmpty ? null : Unit.fromMap(maps.first);
  }

  Future<int> insertUnit(Unit unit) async {
    final db = await _db.database;
    return db.insert('units', unit.toMap());
  }

  Future<int> updateUnitStatus(int id, UnitStatus status) async {
    final db = await _db.database;
    return db.update(
      'units',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

## 4. Model with fromMap/toMap

```dart
@freezed
class Unit with _$Unit {
  const factory Unit({
    required int id,
    required int towerId,
    required int floor,
    required String unitNo,
    required String type,
    required double areaSqft,
    required UnitStatus status,
    required int basePricePaise,
  }) = _Unit;

  factory Unit.fromMap(Map<String, dynamic> map) => Unit(
    id: map['id'] as int,
    towerId: map['tower_id'] as int,
    floor: map['floor'] as int,
    unitNo: map['unit_no'] as String,
    type: map['type'] as String,
    areaSqft: map['area_sqft'] as double,
    status: UnitStatus.values.byName(map['status'] as String),
    basePricePaise: map['base_price'] as int,
  );

  Map<String, dynamic> toMap() => {
    'tower_id': towerId,
    'floor': floor,
    'unit_no': unitNo,
    'type': type,
    'area_sqft': areaSqft,
    'status': status.name,
    'base_price': basePricePaise,
  };
}
```

## 5. Seed Data on First Launch

```dart
Future<void> seedIfEmpty() async {
  final db = await database;
  final count = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM projects')
  ) ?? 0;
  if (count == 0) {
    final json = await rootBundle.loadString('assets/seed/seed_data.json');
    await SeedLoader(db).load(jsonDecode(json));
  }
}
```

## Rules
- Monetary values stored as INTEGER (paise/cents) — never REAL
- Dates stored as ISO 8601 TEXT: `DateTime.now().toIso8601String()`
- All queries parameterized — never string interpolation in SQL
- No raw SQL in providers or screens — repository only
