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

  // Future<void> showProgressNotification(
  //   double value,
  //   String name,
  //   String sub,
  // ) async {
  //   final progress = (value * 100).toInt();
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'task progress channel',
  //     'task progress channel',
  //     channelDescription: 'displays current task progress',
  //     channelShowBadge: false,
  //     priority: Priority.high,
  //     onlyAlertOnce: true,
  //     showProgress: true,
  //     maxProgress: 100,
  //     progress: progress,
  //   );
  //   final NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await _flutterLocalNotificationsPlugin.show(
  //     777,
  //     name,
  //     sub,
  //     platformChannelSpecifics,
  //   );
  // }

  Future<void> scheduledNotification(
      Duration dur, String id, String title, String des) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        ValueKey(id).hashCode,
        title,
        des,
        tz.TZDateTime.now(tz.local).add(dur),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'TaskCompleted', 'Task Completed',
                channelDescription: 'Task Completed Notification')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<NotificationAppLaunchDetails?> getDeviceLaunchInfo() async {
    return await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }

  Future<void> cancelNotification(String id) async {
    await _flutterLocalNotificationsPlugin.cancel(ValueKey(id).hashCode);
  }

  Future<void> cancelNotificationWithId(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
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
        AndroidInitializationSettings('app_icon');

    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    void onSelectNotification(NotificationResponse? response) {
      if (response != null) {
        if (response.payload?.isNotEmpty ?? false) {
          onNotificationClick.add(response.payload);
        }
      }
    }

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }
}
