import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../widgets/in_app_notification.dart';
import '../router/app_router.dart';
import '../router/app_routes.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int waterMorningId = 101;
  static const int waterAfternoonId = 102;
  static const int waterEveningId = 103;

  static const int breakfastId = 201;
  static const int lunchId = 202;
  static const int dinnerId = 203;

  static const int dailyGoalCheckId = 301;
  static const int calorieLimitExceededId = 401;

  static const String _customSoundName = 'notification_sound';

  bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> init() async {
    if (!isSupportedPlatform) {
      return;
    }

    try {
      tz.initializeTimeZones();
      final dynamic tzResult = await FlutterTimezone.getLocalTimezone();

      final String timeZoneName = tzResult is String
          ? tzResult
          : (tzResult?.identifier ?? 'Africa/Cairo');

      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      } catch (_) {}
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'dashboard') {
          AppRouter.router.go(AppRoutes.dashboardScreen);
        }
      },
    );

    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (!isSupportedPlatform) {
      return;
    }

    if (Platform.isAndroid) {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  NotificationDetails _notificationDetails({
    required String channelId,
    required String channelName,
    required String channelDescription,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        sound: const RawResourceAndroidNotificationSound(_customSoundName),
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: '$_customSoundName.mp3',
      ),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!isSupportedPlatform) {
      return;
    }

    final context = AppRouter.navigatorKey.currentContext;

    if (context != null && context.mounted) {
      InAppNotification.show(context, title: title, message: body);
    } else {
      try {
        await _notificationsPlugin.show(
          id: id,
          title: title,
          body: body,
          notificationDetails: _notificationDetails(
            channelId: 'calogram_instant_alerts_sound_v1',
            channelName: 'Instant Alerts',
            channelDescription: 'Real-time quick reminders with sound',
          ),
          payload: payload,
        );
      } catch (_) {}
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    if (!isSupportedPlatform) {
      return;
    }

    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(
          channelId: '${channelId}_sound_v1',
          channelName: channelName,
          channelDescription: 'Daily scheduled reminders with sound',
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (_) {}
  }

  Future<void> cancelNotification(int id) async {
    if (!isSupportedPlatform) return;
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    if (!isSupportedPlatform) return;
    await _notificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
