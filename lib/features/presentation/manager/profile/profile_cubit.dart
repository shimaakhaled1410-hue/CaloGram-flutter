import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:calogram_flutter/features/domain/usecases/user_profile/get_user_profile_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/user_profile/save_user_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final SaveUserProfileUseCase saveUserProfileUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.saveUserProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getUserProfileUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentState.profile));
    }

    final result = await saveUserProfileUseCase(updatedProfile);
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (_) => emit(ProfileUpdatedSuccess(updatedProfile)),
    );
  }
}
