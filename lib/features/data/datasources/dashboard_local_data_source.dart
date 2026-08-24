import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/cache_helper.dart';
import '../models/meal_model.dart';
import '../models/user_model.dart';

abstract class DashboardLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<List<MealModel>> getCachedMeals();
  Future<void> cacheMeals(List<MealModel> meals);
  Future<void> addMealToCache(MealModel meal);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = CacheHelper.getString(
        key: AppConstants.cachedUserProfile,
      );
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> map =
            jsonDecode(jsonString) as Map<String, dynamic>;
        return UserModel(
          uId: CacheHelper.getString(key: AppConstants.cachedUserToken) ?? '',
          email: '',
          name: (map['name'] as String?) ?? 'Champion',
          weight: (map['currentWeight'] as num?)?.toDouble(),
          height: (map['height'] as num?)?.toDouble(),
          targetCalories: (map['targetCalories'] as num?)?.toInt(),
          targetProtein: (map['targetProtein'] as num?)?.toInt(),
          targetCarbs: (map['targetCarbs'] as num?)?.toInt(),
          targetFats: (map['targetFats'] as num?)?.toInt(),
        );
      }
      return null;
    } catch (_) {
      throw CacheException('Failed to get cached dashboard user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final profileMap = {
        'name': user.name.isNotEmpty ? user.name : 'Champion',
        'currentWeight': user.weight ?? 70.0,
        'height': user.height ?? 175.0,
        'targetWeight': user.weight ?? 70.0,
        'targetCalories': user.targetCalories ?? 2000,
        'targetProtein': user.targetProtein ?? 140,
        'targetCarbs': user.targetCarbs ?? 200,
        'targetFats': user.targetFats ?? 65,
      };
      await CacheHelper.setString(
        key: AppConstants.cachedUserProfile,
        value: jsonEncode(profileMap),
      );
    } catch (_) {
      throw CacheException('Failed to cache user');
    }
  }

  @override
  Future<List<MealModel>> getCachedMeals() async {
    try {
      final jsonString = CacheHelper.getString(
        key: AppConstants.cachedTodayMeals,
      );
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
        return list
            .map(
              (item) => MealModel.fromJson(
                item as Map<String, dynamic>,
                item['id'] as String? ?? '',
              ),
            )
            .toList();
      }
      return [];
    } catch (_) {
      throw CacheException('Failed to get cached meals');
    }
  }

  @override
  Future<void> cacheMeals(List<MealModel> meals) async {
    try {
      final list = meals.map((m) => m.toLocalJson()).toList();

      await CacheHelper.setString(
        key: AppConstants.cachedTodayMeals,
        value: jsonEncode(list),
      );
    } catch (e) {
      throw CacheException('Failed to cache meals: $e');
    }
  }

  @override
  Future<void> addMealToCache(MealModel meal) async {
    final currentMeals = await getCachedMeals();
    currentMeals.insert(0, meal);
    await cacheMeals(currentMeals);
  }
}
