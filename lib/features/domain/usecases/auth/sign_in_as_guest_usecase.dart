import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repo/auth_repo.dart';

class SignInAsGuestUseCase {
  final AuthRepo authRepo;
  SignInAsGuestUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call() async {
    return await authRepo.signInAsGuest();
  }
}
