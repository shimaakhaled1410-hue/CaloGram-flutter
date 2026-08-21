import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user_entity.dart';

class RegisterUsecase {
  final AuthRepo authRepo;

  const RegisterUsecase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return authRepo.register(name: name, email: email, password: password);
  }
}
