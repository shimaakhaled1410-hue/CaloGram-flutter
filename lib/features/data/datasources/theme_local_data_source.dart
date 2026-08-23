import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/cache_helper.dart';

abstract class ThemeLocalDataSource {
  ThemeMode getSavedThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  @override
  ThemeMode getSavedThemeMode() {
    final String? themeStr =
        CacheHelper.getString(key: AppConstants.appThemeMode);
    switch (themeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';

    await CacheHelper.setData(key: AppConstants.appThemeMode, value: value);
  }
}