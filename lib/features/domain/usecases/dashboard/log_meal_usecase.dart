import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/meal_entity.dart';
import 'package:calogram_flutter/features/domain/repo/dashboard_repo.dart';
import 'package:dartz/dartz.dart';

class LogMealUsecase {
  final DashboardRepo dashboardRepo;

  const LogMealUsecase(this.dashboardRepo);

  Future<Either<Failure, void>> call(MealEntity meal) {
    return dashboardRepo.logMeal(meal);
  }
}