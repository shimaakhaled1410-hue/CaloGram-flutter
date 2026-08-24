import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../repo/dashboard_repo.dart';

class DeleteMealUsecase {
  final DashboardRepo repository;
  DeleteMealUsecase(this.repository);

  Future<Either<Failure, void>> call(String mealId) async {
    return await repository.deleteMeal(mealId);
  }
}
