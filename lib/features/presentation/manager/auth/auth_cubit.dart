import 'package:calogram_flutter/features/domain/usecases/login_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/logout_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/register_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/update_profile_metrics_usecase.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final UpdateProfileMetricsUsecase updateProfileMetricsUsecase;
  final LogoutUsecase logoutUsecase;

  AuthCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.updateProfileMetricsUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    final result = await loginUsecase(email: email, password: password);
    result.fold(
      (failure) => emit(LoginErrorState(failure.errMessage)),
      (user) => emit(LoginSuccessState(user)),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    final result = await registerUsecase(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(RegisterErrorState(failure.errMessage)),
      (user) => emit(RegisterSuccessState(user)),
    );
  }

  Future<void> updateProfileMetrics({
    required String gender,
    required int age,
    required double height,
    required double weight,
    required String goal,
    required String activityLevel,
    required int targetCalories,
    required int targetProtein,
    required int targetCarbs,
    required int targetFats,
  }) async {
    emit(UpdateMetricsLoadingState());
    final result = await updateProfileMetricsUsecase(
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      goal: goal,
      activityLevel: activityLevel,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFats: targetFats,
    );
    result.fold(
      (failure) => emit(UpdateMetricsErrorState(failure.errMessage)),
      (user) => emit(UpdateMetricsSuccessState(user)),
    );
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await logoutUsecase();
    result.fold(
      (failure) => emit(LogoutErrorState(failure.errMessage)),
      (_) => emit(LogoutSuccessState()),
    );
  }
}