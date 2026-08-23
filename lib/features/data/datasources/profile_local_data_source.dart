import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserProfile(UserProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _profileKey = 'CACHED_USER_PROFILE';

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final jsonString = sharedPreferences.getString(_profileKey);
      if (jsonString != null) {
        final Map<String, dynamic> map = jsonDecode(jsonString);
        return UserProfileModel.fromJson(map);
      } else {
        final defaultProfile = UserProfileModel.defaultProfile();
        await saveUserProfile(defaultProfile);
        return defaultProfile;
      }
    } catch (e) {
      throw CacheException('Failed to get cached profile');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await sharedPreferences.setString(_profileKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save profile');
    }
  }
}
