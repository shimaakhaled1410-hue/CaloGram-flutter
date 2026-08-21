import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> updateProfileMetrics({
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
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
