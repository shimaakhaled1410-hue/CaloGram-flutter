import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/cache_helper.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repo/profile_repo.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepo {
  final ProfileLocalDataSource localDataSource;
  final FirebaseFirestore firestore;

  ProfileRepositoryImpl({
    required this.localDataSource,
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final profileModel = await localDataSource.getUserProfile();
      return Right(profileModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUserProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await localDataSource.saveUserProfile(model);

      final uid = CacheHelper.getString(key: AppConstants.cachedUserToken);
      if (uid != null && uid.isNotEmpty) {
        await firestore.collection('users').doc(uid).update({
          'name': profile.name,
          'weight': profile.currentWeight,
          'height': profile.height,
          'targetWeight': profile.targetWeight,
          'targetCalories': profile.targetCalories,
          'targetProtein': profile.targetProtein,
          'targetCarbs': profile.targetCarbs,
          'targetFats': profile.targetFats,
        });
      }

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore update failed'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
