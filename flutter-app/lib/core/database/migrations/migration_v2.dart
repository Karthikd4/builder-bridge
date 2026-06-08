abstract final class MigrationV2 {
  static const List<String> statements = [
    _interests,
    _idxInterestUser,
    _idxInterestUnit,
  ];

  static const _interests = '''
    CREATE TABLE IF NOT EXISTS interests (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unit_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      status TEXT NOT NULL DEFAULT 'new',
      created_at TEXT NOT NULL,
      FOREIGN KEY (unit_id) REFERENCES units(id),
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const _idxInterestUser = 'CREATE INDEX IF NOT EXISTS idx_interests_user ON interests(user_id)';
  static const _idxInterestUnit = 'CREATE INDEX IF NOT EXISTS idx_interests_unit ON interests(unit_id)';
}
