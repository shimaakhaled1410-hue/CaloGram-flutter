import 'package:flutter/material.dart';
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
          _buildSectionHeader('💧 Water Hydration', primaryAccent),
          const SizedBox(height: 8),
          _buildCard(
            isDark: isDark,
            children: [
              _buildToggleRow(
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
              if (isWaterEnabled) ...[
                const Divider(height: 1),
                _buildTimeTile(
                  label: 'Morning Water',
                  time: waterMorning,
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
                _buildTimeTile(
                  label: 'Afternoon Water',
                  time: waterAfternoon,
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
                _buildTimeTile(
                  label: 'Evening Water',
                  time: waterEvening,
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
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('🥗 Meal Logging', primaryAccent),
          const SizedBox(height: 8),
          _buildCard(
            isDark: isDark,
            children: [
              _buildToggleRow(
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
              if (isBreakfastEnabled)
                _buildTimeTile(
                  label: 'Breakfast Time',
                  time: breakfastTime,
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
              const Divider(height: 1),
              _buildToggleRow(
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
              if (isLunchEnabled)
                _buildTimeTile(
                  label: 'Lunch Time',
                  time: lunchTime,
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
              const Divider(height: 1),
              _buildToggleRow(
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
              if (isDinnerEnabled)
                _buildTimeTile(
                  label: 'Dinner Time',
                  time: dinnerTime,
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required Color primaryAccent,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: primaryAccent,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget _buildTimeTile({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time.format(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      onTap: onTap,
    );
  }
}
