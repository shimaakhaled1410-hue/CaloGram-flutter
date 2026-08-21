import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';

class UpdateProfileMetricsUsecase {
  final AuthRepo authRepo;

  const UpdateProfileMetricsUsecase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String gender,
    required int age,
    required double height,
    required double weight,
    required String goal,
    required String activityLevel,
    required int targetCalories,
    required int targetProtein,
    required int targetCarbs,
    required int targetFats,
  }) {
    return authRepo.updateProfileMetrics(
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      goal: goal,
      activityLevel: activityLevel,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFats: targetFats,
    );
  }
}
