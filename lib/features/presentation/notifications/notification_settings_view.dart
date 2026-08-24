import 'package:calogram_flutter/core/widgets/custom_gradient_button.dart';
import 'package:calogram_flutter/core/widgets/in_app_notification.dart';
import 'package:calogram_flutter/features/presentation/notifications/widgets/notification_card_container.dart';
import 'package:calogram_flutter/features/presentation/notifications/widgets/notification_section_header.dart';
import 'package:calogram_flutter/features/presentation/notifications/widgets/notification_time_tile.dart';
import 'package:calogram_flutter/features/presentation/notifications/widgets/notification_toggle_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/cache_helper.dart';
import '../../../../core/services/notification_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  late bool isWaterEnabled;
  late TimeOfDay waterMorning;
  late TimeOfDay waterAfternoon;
  late TimeOfDay waterEvening;

  late bool isBreakfastEnabled;
  late TimeOfDay breakfastTime;

  late bool isLunchEnabled;
  late TimeOfDay lunchTime;

  late bool isDinnerEnabled;
  late TimeOfDay dinnerTime;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  void _loadSavedSettings() {
    isWaterEnabled =
        CacheHelper.getBool(key: AppConstants.notifWaterEnabled) ?? true;
    waterMorning = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifWaterMorning),
      NotificationHelper.defaultWaterMorning,
    );
    waterAfternoon = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifWaterAfternoon),
      NotificationHelper.defaultWaterAfternoon,
    );
    waterEvening = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifWaterEvening),
      NotificationHelper.defaultWaterEvening,
    );

    isBreakfastEnabled =
        CacheHelper.getBool(key: AppConstants.notifBreakfastEnabled) ?? true;
    breakfastTime = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifBreakfastTime),
      NotificationHelper.defaultBreakfast,
    );

    isLunchEnabled =
        CacheHelper.getBool(key: AppConstants.notifLunchEnabled) ?? true;
    lunchTime = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifLunchTime),
      NotificationHelper.defaultLunch,
    );

    isDinnerEnabled =
        CacheHelper.getBool(key: AppConstants.notifDinnerEnabled) ?? true;
    dinnerTime = NotificationHelper.stringToTime(
      CacheHelper.getString(key: AppConstants.notifDinnerTime),
      NotificationHelper.defaultDinner,
    );
  }

  Future<void> _pickTime({
    required TimeOfDay initialTime,
    required Function(TimeOfDay) onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.primaryNeonLime,
                    onPrimary: AppColors.backgroundDark,
                    surface: AppColors.cardDark,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryLimeDark,
                    onPrimary: Colors.white,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        onSelected(picked);
      });
      await NotificationHelper.syncAllScheduledNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notification Settings',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          NotificationSectionHeader(
            title: 'Water Hydration',
            icon: Icons.water_drop_rounded,
            color: primaryAccent,
          ),
          const SizedBox(height: 8),
          NotificationCardContainer(
            children: [
              NotificationToggleTile(
                title: 'Hydration Reminders',
                subtitle: 'Get alerts to drink water regularly',
                value: isWaterEnabled,
                primaryAccent: primaryAccent,
                onChanged: (val) async {
                  setState(() => isWaterEnabled = val);
                  await CacheHelper.setBool(
                    key: AppConstants.notifWaterEnabled,
                    value: val,
                  );
                  await NotificationHelper.syncAllScheduledNotifications();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.6,
                  color: isDark
                      ? AppColors.inputBorderDark
                      : AppColors.cardLightBorder,
                ),
              ),
              NotificationTimeTile(
                label: 'Morning Water',
                time: waterMorning,
                enabled: isWaterEnabled,
                onTap: () => _pickTime(
                  initialTime: waterMorning,
                  onSelected: (time) {
                    waterMorning = time;
                    CacheHelper.setString(
                      key: AppConstants.notifWaterMorning,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
              NotificationTimeTile(
                label: 'Afternoon Water',
                time: waterAfternoon,
                enabled: isWaterEnabled,
                onTap: () => _pickTime(
                  initialTime: waterAfternoon,
                  onSelected: (time) {
                    waterAfternoon = time;
                    CacheHelper.setString(
                      key: AppConstants.notifWaterAfternoon,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
              NotificationTimeTile(
                label: 'Evening Water',
                time: waterEvening,
                enabled: isWaterEnabled,
                onTap: () => _pickTime(
                  initialTime: waterEvening,
                  onSelected: (time) {
                    waterEvening = time;
                    CacheHelper.setString(
                      key: AppConstants.notifWaterEvening,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          NotificationSectionHeader(
            title: 'Meal Logging',
            icon: Icons.restaurant_rounded,
            color: primaryAccent,
          ),
          const SizedBox(height: 8),
          NotificationCardContainer(
            children: [
              NotificationToggleTile(
                title: 'Breakfast Reminder',
                subtitle: 'Reminder to fuel up and log breakfast',
                value: isBreakfastEnabled,
                primaryAccent: primaryAccent,
                onChanged: (val) async {
                  setState(() => isBreakfastEnabled = val);
                  await CacheHelper.setBool(
                    key: AppConstants.notifBreakfastEnabled,
                    value: val,
                  );
                  await NotificationHelper.syncAllScheduledNotifications();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.6,
                  color: isDark
                      ? AppColors.inputBorderDark
                      : AppColors.cardLightBorder,
                ),
              ),
              NotificationTimeTile(
                label: 'Breakfast Time',
                time: breakfastTime,
                enabled: isBreakfastEnabled,
                onTap: () => _pickTime(
                  initialTime: breakfastTime,
                  onSelected: (time) {
                    breakfastTime = time;
                    CacheHelper.setString(
                      key: AppConstants.notifBreakfastTime,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          NotificationCardContainer(
            children: [
              NotificationToggleTile(
                title: 'Lunch Reminder',
                subtitle: 'Reminder to track your lunch & macros',
                value: isLunchEnabled,
                primaryAccent: primaryAccent,
                onChanged: (val) async {
                  setState(() => isLunchEnabled = val);
                  await CacheHelper.setBool(
                    key: AppConstants.notifLunchEnabled,
                    value: val,
                  );
                  await NotificationHelper.syncAllScheduledNotifications();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.6,
                  color: isDark
                      ? AppColors.inputBorderDark
                      : AppColors.cardLightBorder,
                ),
              ),
              NotificationTimeTile(
                label: 'Lunch Time',
                time: lunchTime,
                enabled: isLunchEnabled,
                onTap: () => _pickTime(
                  initialTime: lunchTime,
                  onSelected: (time) {
                    lunchTime = time;
                    CacheHelper.setString(
                      key: AppConstants.notifLunchTime,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          NotificationCardContainer(
            children: [
              NotificationToggleTile(
                title: 'Dinner Reminder',
                subtitle: 'Check remaining calories for the day',
                value: isDinnerEnabled,
                primaryAccent: primaryAccent,
                onChanged: (val) async {
                  setState(() => isDinnerEnabled = val);
                  await CacheHelper.setBool(
                    key: AppConstants.notifDinnerEnabled,
                    value: val,
                  );
                  await NotificationHelper.syncAllScheduledNotifications();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.6,
                  color: isDark
                      ? AppColors.inputBorderDark
                      : AppColors.cardLightBorder,
                ),
              ),
              NotificationTimeTile(
                label: 'Dinner Time',
                time: dinnerTime,
                enabled: isDinnerEnabled,
                onTap: () => _pickTime(
                  initialTime: dinnerTime,
                  onSelected: (time) {
                    dinnerTime = time;
                    CacheHelper.setString(
                      key: AppConstants.notifDinnerTime,
                      value: NotificationHelper.timeToString(time),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: CustomGradientButton(
              text: 'Send Test Notification',
              onPressed: () {
                InAppNotification.show(
                  context,
                  title: 'Hydration Time!',
                  message: 'Drink water and stay on track today.',
                  accentColor: primaryAccent,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
