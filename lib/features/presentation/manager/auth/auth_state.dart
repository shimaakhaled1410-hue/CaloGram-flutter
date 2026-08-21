import 'package:calogram_flutter/features/domain/entities/user_entity.dart';


abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login States
class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final UserEntity user;
  LoginSuccessState(this.user);
}

class LoginErrorState extends AuthState {
  final String errMessage;
  LoginErrorState(this.errMessage);
}

// Register States
class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {
  final UserEntity user;
  RegisterSuccessState(this.user);
}

class RegisterErrorState extends AuthState {
  final String errMessage;
  RegisterErrorState(this.errMessage);
}

// Profile Metrics Update States (Goal Setup)
class UpdateMetricsLoadingState extends AuthState {}

class UpdateMetricsSuccessState extends AuthState {
  final UserEntity user;
  UpdateMetricsSuccessState(this.user);
}

class UpdateMetricsErrorState extends AuthState {
  final String errMessage;
  UpdateMetricsErrorState(this.errMessage);
}

// Logout States
class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutErrorState extends AuthState {
  final String errMessage;
  LogoutErrorState(this.errMessage);
}