# Skill: Feature Module Patterns

How to scaffold and implement a complete feature module in BuilderBridge.

## Step-by-Step: New Feature Checklist

### 1. Model

```dart
// features/<name>/data/models/<name>_model.dart
@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required int id,
    required int userId,
    required String title,
    required String description,
    required TicketStatus status,
    required DateTime createdAt,
    int? bookingId,
  }) = _Ticket;

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    id: map['id'] as int,
    userId: map['user_id'] as int,
    title: map['title'] as String,
    description: map['description'] as String,
    status: TicketStatus.values.byName(map['status'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
    bookingId: map['booking_id'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'title': title,
    'description': description,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    if (bookingId != null) 'booking_id': bookingId,
  };
}

enum TicketStatus { open, inProgress, resolved, closed }
```

### 2. Repository

```dart
// features/<name>/data/repositories/<name>_repository.dart
class SupportRepository {
  final DatabaseHelper _db;
  SupportRepository(this._db);

  Future<List<Ticket>> getTickets(int userId) async {
    final db = await _db.database;
    final maps = await db.query(
      'tickets',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map(Ticket.fromMap).toList();
  }

  Future<int> createTicket(Ticket ticket) async {
    final db = await _db.database;
    return db.insert('tickets', ticket.toMap());
  }

  Future<void> updateStatus(int id, TicketStatus status) async {
    final db = await _db.database;
    await db.update(
      'tickets',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

### 3. Provider

```dart
// features/<name>/presentation/providers/<name>_provider.dart
final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.read(databaseProvider));
});

@riverpod
class TicketsNotifier extends _$TicketsNotifier {
  @override
  Future<List<Ticket>> build() async {
    final userId = ref.watch(currentUserProvider).value?.id ?? 0;
    return ref.read(supportRepositoryProvider).getTickets(userId);
  }

  Future<void> create(String title, String description) async {
    final userId = ref.read(currentUserProvider).value!.id;
    final ticket = Ticket(
      id: 0,
      userId: userId,
      title: title,
      description: description,
      status: TicketStatus.open,
      createdAt: DateTime.now(),
    );
    await ref.read(supportRepositoryProvider).createTicket(ticket);
    ref.invalidateSelf();
  }
}
```

### 4. Screen

```dart
// features/<name>/presentation/screens/<name>_screen.dart
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(ticketsNotifierProvider);
    return Scaffold(
      appBar: BBAppBar(
        title: 'Support',
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => context.push('/support/new'))],
      ),
      body: ticketsAsync.when(
        data: (tickets) => tickets.isEmpty
            ? const BBEmptyState(message: 'No tickets yet', ctaLabel: 'Create Ticket')
            : TicketList(tickets: tickets),
        loading: () => const BBLoadingState(),
        error: (e, _) => BBErrorState(
          message: 'Could not load tickets',
          onRetry: () => ref.refresh(ticketsNotifierProvider),
        ),
      ),
    );
  }
}
```

### 5. Register Route

```dart
// core/navigation/app_router.dart — add to ShellRoute routes:
GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
GoRoute(path: '/support/:id', builder: (_, state) =>
    TicketDetailScreen(ticketId: int.parse(state.pathParameters['id']!))),
GoRoute(path: '/support/new', builder: (_, __) => const CreateTicketScreen()),
```

## Module Boundaries

```
✅ Feature can import from: own feature, core/, shared/
❌ Feature cannot import from: another feature's repositories or providers
   → If shared data needed: expose via core/ or create shared provider
```
