import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/cache_helper.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserProfile(UserProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final jsonString = CacheHelper.getString(
        key: AppConstants.cachedUserProfile,
      );
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> map =
            jsonDecode(jsonString) as Map<String, dynamic>;
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
      await CacheHelper.setString(
        key: AppConstants.cachedUserProfile,
        value: jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to save profile');
    }
  }
}
