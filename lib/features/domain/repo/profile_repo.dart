import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, Unit>> saveUserProfile(UserProfile profile);
}
