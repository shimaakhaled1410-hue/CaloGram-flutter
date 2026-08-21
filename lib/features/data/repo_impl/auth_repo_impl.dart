import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/cache_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await CacheHelper.setData(key: AppConstants.cachedUserToken, value: user.uId);
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapFirebaseAuthException(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await CacheHelper.setData(key: AppConstants.cachedUserToken, value: user.uId);
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapFirebaseAuthException(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final String? cachedUid =
          CacheHelper.getString(key: AppConstants.cachedUserToken);
      if (cachedUid == null || cachedUid.isEmpty) {
        return Left(ServerFailure('User session not found'));
      }

      final Map<String, dynamic> data = {
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'goal': goal,
        'activityLevel': activityLevel,
        'targetCalories': targetCalories,
        'targetProtein': targetProtein,
        'targetCarbs': targetCarbs,
        'targetFats': targetFats,
      };

      final updatedUser = await remoteDataSource.updateProfileMetrics(
        uId: cachedUid,
        updatedData: data,
      );

      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final String? cachedUid =
          CacheHelper.getString(key: AppConstants.cachedUserToken);
      if (cachedUid == null || cachedUid.isEmpty) {
        return Left(ServerFailure('No active user session'));
      }
      final user = await remoteDataSource.getCurrentUser(cachedUid);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await CacheHelper.removeData(key: AppConstants.cachedUserToken);
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
    }
  }
}