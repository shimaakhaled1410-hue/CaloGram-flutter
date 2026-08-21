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