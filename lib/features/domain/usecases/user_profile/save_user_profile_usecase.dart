import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:calogram_flutter/features/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class SaveUserProfileUseCase {
  final ProfileRepo repository;

  SaveUserProfileUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UserProfile profile) {
    return repository.saveUserProfile(profile);
  }
}
