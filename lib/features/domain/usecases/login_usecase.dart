import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

class LoginUsecase {
  final AuthRepo authRepo;

  const LoginUsecase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return authRepo.login(email: email, password: password);
  }
}
