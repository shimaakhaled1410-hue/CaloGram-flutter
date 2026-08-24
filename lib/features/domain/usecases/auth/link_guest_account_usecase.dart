import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';
import '../../repo/auth_repo.dart';

class LinkGuestAccountUseCase {
  final AuthRepo authRepo;
  LinkGuestAccountUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await authRepo.linkGuestAccount(
      name: name,
      email: email,
      password: password,
    );
  }
}
