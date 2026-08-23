import 'dart:convert';
import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/cache_helper.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repo/dashboard_repo.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/meal_model.dart';
import '../models/user_model.dart';

class DashboardRepoImpl implements DashboardRepo {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepoImpl({required this.remoteDataSource});

  String _getUid() {
    final uid = CacheHelper.getString(key: AppConstants.cachedUserToken);
    if (uid == null || uid.isEmpty) {
      throw AuthException('Active user session not found');
    }
    return uid;
  }

  @override
  Future<Either<Failure, UserEntity>> fetchUserProfile() async {
    try {
      final uid = _getUid();

      final String? cachedJson = CacheHelper.getString(
        key: 'CACHED_USER_PROFILE',
      );
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(cachedJson);
        return Right(
          UserModel(
            uId: uid,
            email: '',
            name: data['name'] ?? 'Champion',
            weight: (data['currentWeight'] as num?)?.toDouble(),
            height: (data['height'] as num?)?.toDouble(),
            targetCalories: (data['targetCalories'] as num?)?.toInt(),
            targetProtein: (data['targetProtein'] as num?)?.toInt(),
            targetCarbs: (data['targetCarbs'] as num?)?.toInt(),
            targetFats: (data['targetFats'] as num?)?.toInt(),
          ),
        );
      }

      final user = await remoteDataSource.fetchUserProfile(uid);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch user profile'));
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> fetchTodayMeals() async {
    try {
      final uid = _getUid();
      final meals = await remoteDataSource.fetchTodayMeals(uid);
      return Right(meals);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch meals'));
    }
  }

  @override
  Future<Either<Failure, void>> logMeal(MealEntity meal) async {
    try {
      final uid = _getUid();
      final mealModel = MealModel(
        id: meal.id,
        title: meal.title,
        mealType: meal.mealType,
        calories: meal.calories,
        protein: meal.protein,
        carbs: meal.carbs,
        fats: meal.fats,
        loggedAt: meal.loggedAt,
      );
      await remoteDataSource.logMeal(uid, mealModel);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to log meal'));
    }
  }
}
