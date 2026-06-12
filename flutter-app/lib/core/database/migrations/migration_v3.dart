abstract final class MigrationV3 {
  static const List<String> statements = [
    _adminUsers,
    _idxAdminEmail,
  ];

  static const _adminUsers = '''
    CREATE TABLE IF NOT EXISTS admin_users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      phone TEXT,
      role TEXT NOT NULL DEFAULT 'viewer',
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL
    )
  ''';

  static const _idxAdminEmail =
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email)';
}
