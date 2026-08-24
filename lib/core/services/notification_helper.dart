import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'cache_helper.dart';
import 'notification_service.dart';

class NotificationHelper {
  NotificationHelper._();

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
      final t1 = stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterMorning),
        defaultWaterMorning,
      );
      final t2 = stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterAfternoon),
        defaultWaterAfternoon,
      );
      final t3 = stringToTime(
        CacheHelper.getString(key: AppConstants.notifWaterEvening),
        defaultWaterEvening,
      );

      await service.scheduleDailyNotification(
        id: NotificationService.waterMorningId,
        title: 'Time to Hydrate!',
        body: 'Start your morning strong with a fresh glass of water.',
        time: t1,
        channelId: 'water_reminders',
        channelName: 'Water Reminders',
        payload: 'dashboard',
      );

      await service.scheduleDailyNotification(
        id: NotificationService.waterAfternoonId,
        title: 'Afternoon Hydration Boost',
        body: 'Keep your energy high! Drink a glass of water now.',
        time: t2,
        channelId: 'water_reminders',
        channelName: 'Water Reminders',
        payload: 'dashboard',
      );

      await service.scheduleDailyNotification(
        id: NotificationService.waterEveningId,
        title: 'Evening Water Check',
        body: 'Stay hydrated before your evening routine.',
        time: t3,
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
      final t = stringToTime(
        CacheHelper.getString(key: AppConstants.notifBreakfastTime),
        defaultBreakfast,
      );
      await service.scheduleDailyNotification(
        id: NotificationService.breakfastId,
        title: 'Breakfast Time!',
        body: 'Fuel up for the day and remember to log your breakfast.',
        time: t,
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
      final t = stringToTime(
        CacheHelper.getString(key: AppConstants.notifLunchTime),
        defaultLunch,
      );
      await service.scheduleDailyNotification(
        id: NotificationService.lunchId,
        title: 'Healthy Lunch Break',
        body: 'Time for lunch! Keep track of your calories and macros.',
        time: t,
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
      final t = stringToTime(
        CacheHelper.getString(key: AppConstants.notifDinnerTime),
        defaultDinner,
      );
      await service.scheduleDailyNotification(
        id: NotificationService.dinnerId,
        title: 'Dinner & Day Wrap-up',
        body: 'Enjoy your dinner and check your remaining calorie target.',
        time: t,
        channelId: 'meal_reminders',
        channelName: 'Meal Reminders',
        payload: 'dashboard',
      );
    } else {
      await service.cancelNotification(NotificationService.dinnerId);
    }
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
