import 'package:flutter/material.dart';
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
    required String title,
    required String body,
    required String uId,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          '001',
          'Notifications',
          channelDescription: 'Notifications',
          tag: uId,
        ),
      ),
    );
  }

  Future<void> scheduleDaily({
    required TimeOfDay time,
    required String title,
    required String des,
    required String uId,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      ValueKey(uId).hashCode,
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
      payload: uId,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWeekly({
    required TimeOfDay time,
    required String title,
    required String des,
    required String day,
    required String uId,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      ValueKey(uId + day).hashCode,
      title,
      des,
      _scheduleWeekly(time, day),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '003',
          'Weekly Routine Notifications',
          channelDescription: 'Weekly Routine Notifications',
        ),
      ),
      payload: uId,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<NotificationAppLaunchDetails?> getDeviceLaunchInfo() async {
    return await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }

  Future<void> cancelNotification(String id) async {
    await _flutterLocalNotificationsPlugin.cancel(ValueKey(id).hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _dailyAt(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _scheduleWeekly(
    TimeOfDay time,
    String day,
  ) {
    tz.TZDateTime scheduledDate = _dailyAt(time);
    var cDay = DateFormat('EEEE').format(scheduledDate);
    while (cDay != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      cDay = DateFormat('EEEE').format(scheduledDate);
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
