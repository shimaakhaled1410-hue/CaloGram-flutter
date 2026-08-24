import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'cache_helper.dart';
import 'notification_service.dart';

class NotificationHelper {
  NotificationHelper._();

  static final List<Timer> _foregroundTimers = [];

  static const TimeOfDay defaultWaterMorning = TimeOfDay(hour: 10, minute: 0);
  static const TimeOfDay defaultWaterAfternoon = TimeOfDay(
    hour: 14,
    minute: 30,
  );
  static const TimeOfDay defaultWaterEvening = TimeOfDay(hour: 19, minute: 0);

  static const TimeOfDay defaultBreakfast = TimeOfDay(hour: 9, minute: 0);
  static const TimeOfDay defaultLunch = TimeOfDay(hour: 14, minute: 30);
  static const TimeOfDay defaultDinner = TimeOfDay(hour: 20, minute: 30);

  static String timeToString(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static TimeOfDay stringToTime(String? timeStr, TimeOfDay defaultTime) {
    if (timeStr == null || !timeStr.contains(':')) return defaultTime;
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? defaultTime.hour,
      minute: int.tryParse(parts[1]) ?? defaultTime.minute,
    );
  }

  static Future<void> syncAllScheduledNotifications() async {
    final service = NotificationService.instance;

    final isWaterEnabled =
        CacheHelper.getBool(key: AppConstants.notifWaterEnabled) ?? true;
    if (isWaterEnabled) {
      await service.scheduleDailyNotification(
        id: NotificationService.waterMorningId,
        title: 'Time to Hydrate!',
        body: 'Start your morning strong with a fresh glass of water.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifWaterMorning),
          defaultWaterMorning,
        ),
        channelId: 'water_reminders',
        channelName: 'Water Reminders',
        payload: 'dashboard',
      );
      await service.scheduleDailyNotification(
        id: NotificationService.waterAfternoonId,
        title: 'Afternoon Hydration Boost',
        body: 'Keep your energy high! Drink a glass of water now.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifWaterAfternoon),
          defaultWaterAfternoon,
        ),
        channelId: 'water_reminders',
        channelName: 'Water Reminders',
        payload: 'dashboard',
      );
      await service.scheduleDailyNotification(
        id: NotificationService.waterEveningId,
        title: 'Evening Water Check',
        body: 'Stay hydrated before your evening routine.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifWaterEvening),
          defaultWaterEvening,
        ),
        channelId: 'water_reminders',
        channelName: 'Water Reminders',
        payload: 'dashboard',
      );
    } else {
      await service.cancelNotification(NotificationService.waterMorningId);
      await service.cancelNotification(NotificationService.waterAfternoonId);
      await service.cancelNotification(NotificationService.waterEveningId);
    }

    final isBreakfastEnabled =
        CacheHelper.getBool(key: AppConstants.notifBreakfastEnabled) ?? true;
    if (isBreakfastEnabled) {
      await service.scheduleDailyNotification(
        id: NotificationService.breakfastId,
        title: 'Breakfast Time!',
        body: 'Fuel up for the day and remember to log your breakfast.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifBreakfastTime),
          defaultBreakfast,
        ),
        channelId: 'meal_reminders',
        channelName: 'Meal Reminders',
        payload: 'dashboard',
      );
    } else {
      await service.cancelNotification(NotificationService.breakfastId);
    }

    final isLunchEnabled =
        CacheHelper.getBool(key: AppConstants.notifLunchEnabled) ?? true;
    if (isLunchEnabled) {
      await service.scheduleDailyNotification(
        id: NotificationService.lunchId,
        title: 'Healthy Lunch Break',
        body: 'Time for lunch! Keep track of your calories and macros.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifLunchTime),
          defaultLunch,
        ),
        channelId: 'meal_reminders',
        channelName: 'Meal Reminders',
        payload: 'dashboard',
      );
    } else {
      await service.cancelNotification(NotificationService.lunchId);
    }

    final isDinnerEnabled =
        CacheHelper.getBool(key: AppConstants.notifDinnerEnabled) ?? true;
    if (isDinnerEnabled) {
      await service.scheduleDailyNotification(
        id: NotificationService.dinnerId,
        title: 'Dinner & Day Wrap-up',
        body: 'Enjoy your dinner and check your remaining calorie target.',
        time: stringToTime(
          CacheHelper.getString(key: AppConstants.notifDinnerTime),
          defaultDinner,
        ),
        channelId: 'meal_reminders',
        channelName: 'Meal Reminders',
        payload: 'dashboard',
      );
    } else {
      await service.cancelNotification(NotificationService.dinnerId);
    }

    syncForegroundTimers();
  }

  static void syncForegroundTimers() {
    cancelForegroundTimers();
    final now = DateTime.now();

    void scheduleOneShot(
      bool isEnabled,
      TimeOfDay time,
      int id,
      String title,
      String body,
    ) {
      if (!isEnabled) return;
      var targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      if (targetTime.isAfter(now)) {
        final duration = targetTime.difference(now);
        final timer = Timer(duration, () {
          NotificationService.instance.showInstantNotification(
            id: id,
            title: title,
            body: body,
          );
        });
        _foregroundTimers.add(timer);
      }
    }

    final isWaterEnabled =
        CacheHelper.getBool(key: AppConstants.notifWaterEnabled) ?? true;
    scheduleOneShot(
      isWaterEnabled,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterMorning),
        defaultWaterMorning,
      ),
      NotificationService.waterMorningId,
      'Time to Hydrate!',
      'Start your morning strong with a fresh glass of water.',
    );
    scheduleOneShot(
      isWaterEnabled,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterAfternoon),
        defaultWaterAfternoon,
      ),
      NotificationService.waterAfternoonId,
      'Afternoon Hydration Boost',
      'Keep your energy high! Drink a glass of water now.',
    );
    scheduleOneShot(
      isWaterEnabled,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterEvening),
        defaultWaterEvening,
      ),
      NotificationService.waterEveningId,
      'Evening Water Check',
      'Stay hydrated before your evening routine.',
    );

    scheduleOneShot(
      CacheHelper.getBool(key: AppConstants.notifBreakfastEnabled) ?? true,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifBreakfastTime),
        defaultBreakfast,
      ),
      NotificationService.breakfastId,
      'Breakfast Time!',
      'Fuel up for the day and remember to log your breakfast.',
    );
    scheduleOneShot(
      CacheHelper.getBool(key: AppConstants.notifLunchEnabled) ?? true,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifLunchTime),
        defaultLunch,
      ),
      NotificationService.lunchId,
      'Healthy Lunch Break',
      'Time for lunch! Keep track of your calories and macros.',
    );
    scheduleOneShot(
      CacheHelper.getBool(key: AppConstants.notifDinnerEnabled) ?? true,
      stringToTime(
        CacheHelper.getString(key: AppConstants.notifDinnerTime),
        defaultDinner,
      ),
      NotificationService.dinnerId,
      'Dinner & Day Wrap-up',
      'Enjoy your dinner and check your remaining calorie target.',
    );
  }

  static void cancelForegroundTimers() {
    for (var timer in _foregroundTimers) {
      timer.cancel();
    }
    _foregroundTimers.clear();
  }

  static Future<void> checkAndNotifyCalorieLimit({
    required int totalCalories,
    required int targetCalories,
  }) async {
    if (targetCalories <= 0) return;

    if (totalCalories > targetCalories) {
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      final alertKey = 'calorie_exceeded_alert_$todayStr';
      final alreadySentToday = CacheHelper.getBool(key: alertKey) ?? false;

      if (!alreadySentToday) {
        await NotificationService.instance.showInstantNotification(
          id: NotificationService.calorieLimitExceededId,
          title: 'Calorie Target Exceeded!',
          body:
              'You have passed your target of $targetCalories kcal (Current: $totalCalories kcal). Balance with light activity!',
          payload: 'dashboard',
        );
        await CacheHelper.setBool(key: alertKey, value: true);
      }
    }
  }
}
