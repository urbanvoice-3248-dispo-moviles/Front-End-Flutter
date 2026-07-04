import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/alert_config.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/alert_config_usecases.dart';
import '../../../domain/usecases/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileById getProfileById;
  final GetProfileByEmail getProfileByEmail;
  final UpdateProfile updateProfile;
  final DeleteProfile deleteProfile;
  final GetAlertConfig getAlertConfig;
  final UpdateAlertConfig updateAlertConfig;

  ProfileBloc({
    required this.getProfileById,
    required this.getProfileByEmail,
    required this.updateProfile,
    required this.deleteProfile,
    required this.getAlertConfig,
    required this.updateAlertConfig,
  }) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteProfileEvent>(_onDeleteProfile);
    on<GetAlertConfigEvent>(_onGetAlertConfig);
    on<UpdateAlertConfigEvent>(_onUpdateAlertConfig);
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

  Future<void> _onGetAlertConfig(
      GetAlertConfigEvent event, Emitter<ProfileState> emit) async {
    final result = await getAlertConfig(event.userId);
    result.fold(
      (_) {},
      (config) {
        if (state is ProfileLoaded) {
          final current = state as ProfileLoaded;
          emit(ProfileLoaded(current.profile, alertConfig: config));
        }
      },
    );
  }

  Future<void> _onUpdateAlertConfig(
      UpdateAlertConfigEvent event, Emitter<ProfileState> emit) async {
    final result = await updateAlertConfig(
      userId: event.userId,
      enabled: event.enabled,
      radiusInKm: event.radiusInKm,
      notifyByEmail: event.notifyByEmail,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (config) {
        if (state is ProfileLoaded) {
          final current = state as ProfileLoaded;
          emit(ProfileLoaded(current.profile, alertConfig: config));
        }
      },
    );
  }
}
