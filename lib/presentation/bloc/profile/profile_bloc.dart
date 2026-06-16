import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileById getProfileById;
  final GetProfileByEmail getProfileByEmail;
  final UpdateProfile updateProfile;
  final DeleteProfile deleteProfile;

  ProfileBloc({
    required this.getProfileById,
    required this.getProfileByEmail,
    required this.updateProfile,
    required this.deleteProfile,
  }) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onGetProfile(
      GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getProfileById(event.id);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await updateProfile(
      id: event.id,
      name: event.name,
      lastName: event.lastName,
      age: event.age,
      phoneNumber: event.phoneNumber,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onDeleteProfile(
      DeleteProfileEvent event, Emitter<ProfileState> emit) async {
    final result = await deleteProfile(event.id);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileDeleted()),
    );
  }
}
