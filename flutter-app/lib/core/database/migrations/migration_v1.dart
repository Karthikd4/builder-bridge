abstract final class MigrationV1 {
  static const List<String> statements = [
    _users,
    _sessions,
    _projects,
    _towers,
    _units,
    _estimates,
    _bookings,
    _paymentMilestones,
    _receipts,
    _documents,
    _tickets,
    _ticketComments,
    _notifications,
    _pendingSync,
    _idxUnitStatus,
    _idxUnitTower,
    _idxMilestoneDue,
    _idxTicketStatus,
    _idxNotifUser,
  ];

  static const _users = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT NOT NULL UNIQUE,
      name TEXT,
      email TEXT,
      created_at TEXT NOT NULL
    )
  ''';

  static const _sessions = '''
    CREATE TABLE sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      token TEXT NOT NULL,
      expires_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const _projects = '''
    CREATE TABLE projects (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      builder_name TEXT NOT NULL,
      location TEXT NOT NULL,
      description TEXT,
      created_at TEXT NOT NULL
    )
  ''';

  static const _towers = '''
    CREATE TABLE towers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      project_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      total_floors INTEGER NOT NULL,
      FOREIGN KEY (project_id) REFERENCES projects(id)
    )
  ''';

  static const _units = '''
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
    )
  ''';

  static const _estimates = '''
    CREATE TABLE estimates (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unit_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      base_price INTEGER NOT NULL,
      discounts INTEGER NOT NULL DEFAULT 0,
      total INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (unit_id) REFERENCES units(id),
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const _bookings = '''
    CREATE TABLE bookings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unit_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      status TEXT NOT NULL DEFAULT 'reserved',
      token_amount INTEGER NOT NULL DEFAULT 0,
      booked_at TEXT NOT NULL,
      FOREIGN KEY (unit_id) REFERENCES units(id),
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const _paymentMilestones = '''
    CREATE TABLE payment_milestones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      label TEXT NOT NULL,
      amount INTEGER NOT NULL,
      due_date TEXT NOT NULL,
      paid_at TEXT,
      FOREIGN KEY (booking_id) REFERENCES bookings(id)
    )
  ''';

  static const _receipts = '''
    CREATE TABLE receipts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      milestone_id INTEGER NOT NULL,
      amount INTEGER NOT NULL,
      receipt_path TEXT,
      uploaded_at TEXT NOT NULL,
      FOREIGN KEY (milestone_id) REFERENCES payment_milestones(id)
    )
  ''';

  static const _documents = '''
    CREATE TABLE documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER NOT NULL,
      type TEXT NOT NULL,
      name TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      file_path TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES bookings(id)
    )
  ''';

  static const _tickets = '''
    CREATE TABLE tickets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      booking_id INTEGER,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'open',
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (booking_id) REFERENCES bookings(id)
    )
  ''';

  static const _ticketComments = '''
    CREATE TABLE ticket_comments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ticket_id INTEGER NOT NULL,
      author TEXT NOT NULL,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (ticket_id) REFERENCES tickets(id)
    )
  ''';

  static const _notifications = '''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      body TEXT NOT NULL,
      read_at TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const _pendingSync = '''
    CREATE TABLE pending_sync (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id INTEGER,
      operation TEXT NOT NULL,
      payload TEXT NOT NULL,
      created_at TEXT NOT NULL,
      synced_at TEXT
    )
  ''';

  // Indexes
  static const _idxUnitStatus  = 'CREATE INDEX idx_units_status ON units(status)';
  static const _idxUnitTower   = 'CREATE INDEX idx_units_tower ON units(tower_id)';
  static const _idxMilestoneDue = 'CREATE INDEX idx_milestones_due ON payment_milestones(due_date)';
  static const _idxTicketStatus = 'CREATE INDEX idx_tickets_status ON tickets(status)';
  static const _idxNotifUser   = 'CREATE INDEX idx_notifications_user ON notifications(user_id)';
}
