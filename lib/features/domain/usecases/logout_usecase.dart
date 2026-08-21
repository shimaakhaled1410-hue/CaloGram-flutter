import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase {
  final AuthRepo authRepo;

  const LogoutUsecase(this.authRepo);

  Future<Either<Failure, void>> call() {
    return authRepo.logout();
  }
}
