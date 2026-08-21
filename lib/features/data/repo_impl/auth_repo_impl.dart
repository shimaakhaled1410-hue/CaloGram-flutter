import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/cache_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repo/auth_repo.dart';
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
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      await CacheHelper.setData(
        key: AppConstants.cachedUserToken,
        value: user.uId,
      );
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred'));
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
      await CacheHelper.setData(
        key: AppConstants.cachedUserToken,
        value: user.uId,
      );
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred'));
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
        return Left(AuthFailure('User session not found'));
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
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final String? cachedUid =
          CacheHelper.getString(key: AppConstants.cachedUserToken);
      if (cachedUid == null || cachedUid.isEmpty) {
        return const Right(null);
      }
      final user = await remoteDataSource.getCurrentUser(cachedUid);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.signOut();
      await CacheHelper.removeData(key: AppConstants.cachedUserToken);
      await CacheHelper.setData(key: AppConstants.isGuestUser, value: false);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to sign out'));
    }
  }
}