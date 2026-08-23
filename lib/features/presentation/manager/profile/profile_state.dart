import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdating extends ProfileState {
  final UserProfile currentProfile;
  const ProfileUpdating(this.currentProfile);

  @override
  List<Object?> get props => [currentProfile];
}

class ProfileUpdatedSuccess extends ProfileState {
  final UserProfile profile;
  const ProfileUpdatedSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
