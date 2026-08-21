import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/meal_entity.dart';
import '../entities/user_entity.dart';

abstract class DashboardRepo {
  Future<Either<Failure, UserEntity>> fetchUserProfile();
  Future<Either<Failure, List<MealEntity>>> fetchTodayMeals();
  Future<Either<Failure, void>> logMeal(MealEntity meal);
}
