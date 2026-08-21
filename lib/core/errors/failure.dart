abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.errMessage);
}

class AuthFailure extends Failure {
  AuthFailure(super.errMessage);
}

class CacheFailure extends Failure {
  CacheFailure(super.errMessage);
}