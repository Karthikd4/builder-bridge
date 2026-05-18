# Skill: Notification Patterns

Local notification patterns for BuilderBridge using `flutter_local_notifications` ^17.x.

## Setup

```dart
// lib/core/notifications/notification_service.dart
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false, // Request at point of use
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    await _createChannels();
  }

  static Future<void> _createChannels() async {
    const channel = AndroidNotificationChannel(
      'payment_reminders',
      'Payment Reminders',
      description: 'Upcoming payment due date reminders',
      importance: Importance.high,
    );
    await _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Navigate based on payload
    final payload = response.payload;
    if (payload != null) {
      _router.push(payload); // inject router
    }
  }
}
```

## Notification Types

```dart
enum BBNotificationType {
  paymentDue,      // payload: '/payments'
  ticketUpdated,   // payload: '/support'
  documentReady,   // payload: '/documents'
  bookingConfirmed // payload: '/dashboard'
}
```

## Schedule Payment Reminder

```dart
Future<void> schedulePaymentReminder({
  required int milestoneId,
  required String label,
  required int amountPaise,
  required DateTime dueDate,
}) async {
  final scheduledDate = tz.TZDateTime.from(
    dueDate.subtract(const Duration(days: 3)), // 3 days before
    tz.local,
  );

  await _plugin.zonedSchedule(
    milestoneId,
    'Payment Due in 3 Days',
    '$label — ${formatAmount(amountPaise)}',
    scheduledDate,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'payment_reminders',
        'Payment Reminders',
        channelDescription: 'Upcoming payment due date reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: '/payments',
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

## Permission Request (at point of use)

```dart
// Request only when user enables notifications in Settings screen
Future<bool> requestPermission() async {
  final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  final granted = await android?.requestNotificationsPermission() ?? false;
  return granted;
}
```

## Notification Provider

```dart
@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<List<AppNotification>> build() {
    return ref.read(notificationsRepositoryProvider).getAll();
  }

  Future<void> markRead(int id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    ref.invalidateSelf();
  }

  Future<void> markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    ref.invalidateSelf();
  }
}
```

## Rules
- Request permissions at point of use (settings screen), not on app launch
- Schedule payment reminders when booking is confirmed
- Cancel notifications when payment is marked paid
- Store notification history in SQLite `notifications` table
- Deep-link via `payload` string matching go_router routes
