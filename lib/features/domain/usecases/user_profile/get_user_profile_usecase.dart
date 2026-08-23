import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:calogram_flutter/features/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileUseCase {
  final ProfileRepo repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call() {
    return repository.getUserProfile();
  }
}
