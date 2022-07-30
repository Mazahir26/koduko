import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '001',
          'Notifications',
          channelDescription: 'Notifications',
        ),
      ),
    );
  }

  Future<void> scheduleDaily(
      {required int time,
      required String title,
      required String des,
      required int id}) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      des,
      _dailyAt(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '002',
          'Daily Routine Notifications',
          channelDescription: 'Daily Routine Notifications',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWeekly({
    required int time,
    required String title,
    required String des,
    required int id,
    required List<String> days,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      des,
      _scheduleWeekly(time, days),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '003',
          'Weekly Routine Notifications',
          channelDescription: 'Weekly Routine Notifications',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  tz.TZDateTime _dailyAt(int time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, time);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _scheduleWeekly(
    int time,
    List<String> days,
  ) {
    tz.TZDateTime scheduledDate = _dailyAt(time);
    while (!days.contains(DateFormat("EEEE").format(scheduledDate))) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('icon');

    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    void onSelectNotification(String? payload) {
      if (payload != null && payload.isNotEmpty) {
        onNotificationClick.add(payload);
      }
    }

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }
}
