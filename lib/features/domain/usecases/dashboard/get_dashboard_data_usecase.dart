import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/meal_entity.dart';
import 'package:calogram_flutter/features/domain/entities/user_entity.dart';
import 'package:calogram_flutter/features/domain/repo/dashboard_repo.dart';
import 'package:dartz/dartz.dart';

class DashboardData {
  final UserEntity user;
  final List<MealEntity> meals;

  const DashboardData({
    required this.user,
    required this.meals,
  });
}

class GetDashboardDataUsecase {
  final DashboardRepo dashboardRepo;

  const GetDashboardDataUsecase(this.dashboardRepo);

  Future<Either<Failure, DashboardData>> call() async {
    final userResult = await dashboardRepo.fetchUserProfile();

    return userResult.fold(
      (failure) => Left(failure),
      (user) async {
        final mealsResult = await dashboardRepo.fetchTodayMeals();
        return mealsResult.fold(
          (failure) => Left(failure),
          (meals) => Right(DashboardData(user: user, meals: meals)),
        );
      },
    );
  }
}