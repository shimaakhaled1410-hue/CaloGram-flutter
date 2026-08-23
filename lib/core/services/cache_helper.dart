import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setString({
    required String key,
    required String value,
  }) async {
    return await _preferences.setString(key, value);
  }

  static Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    return await _preferences.setBool(key, value);
  }

  static Future<bool> setInt({
    required String key,
    required int value,
  }) async {
    return await _preferences.setInt(key, value);
  }

  static Future<bool> setDouble({
    required String key,
    required double value,
  }) async {
    return await _preferences.setDouble(key, value);
  }

  static bool? getBool({required String key}) {
    return _preferences.getBool(key);
  }

  static String? getString({required String key}) {
    return _preferences.getString(key);
  }

  static int? getInt({required String key}) {
    return _preferences.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _preferences.getDouble(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _preferences.remove(key);
  }

  static Future<bool> clearAllData() async {
    return await _preferences.clear();
  }
}