import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleDailyReminders() async {
    final List<int> hours = [9, 14, 19];

    for (int i = 0; i < hours.length; i++) {
      await _notificationsPlugin.zonedSchedule(
        i,
        "Waktunya Cek Tugas! 🐾",
        "Ayo selesaikan tugasmu agar Pet tetap sehat.",
        _nextInstanceOfHour(hours[i]),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        // Perbaikan di sini: uiLocalNotificationDateInterpretation dihapus di versi terbaru
        // karena sistem timezone sekarang ditangani secara otomatis oleh TZDateTime
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, 
      );
    }
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}