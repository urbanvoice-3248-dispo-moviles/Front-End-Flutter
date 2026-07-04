import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/share_session.dart';

import '../../../domain/usecases/location_sharing_usecases.dart';
import '../../../domain/usecases/profile_usecases.dart';

part 'location_sharing_event.dart';
part 'location_sharing_state.dart';

class LocationSharingBloc
    extends Bloc<LocationSharingEvent, LocationSharingState> {
  final PublishLocation publishLocation;
  final GetFriendsLocations getFriendsLocations;
  final StartSharing startSharing;
  final StopSharing stopSharing;
  final GetMyShares getMyShares;
  final GetSharedWithMe getSharedWithMe;
  final GetProfileByEmail getProfileByEmail;

  LocationSharingBloc({
    required this.publishLocation,
    required this.getFriendsLocations,
    required this.startSharing,
    required this.stopSharing,
    required this.getMyShares,
    required this.getSharedWithMe,
    required this.getProfileByEmail,
  }) : super(const LocationSharingInitial()) {
    on<PublishMyLocationEvent>(_onPublish);
    on<LoadSharingDataEvent>(_onLoadData);
    on<StartSharingEvent>(_onStartSharing);
    on<StopSharingEvent>(_onStopSharing);
    on<LoadFriendsLocationsEvent>(_onLoadFriends);
    on<ClearAddContactErrorEvent>(_onClearError);
  }

  Future<void> _onPublish(
      PublishMyLocationEvent event, Emitter<LocationSharingState> emit) async {
    final result = await publishLocation(
      latitude: event.latitude,
      longitude: event.longitude,
      userId: event.userId,
    );
    result.fold(
      (_) {},
      (location) => emit(state.copyWith(myLocation: location)),
    );
  }

  Future<void> _onLoadData(
      LoadSharingDataEvent event, Emitter<LocationSharingState> emit) async {
    emit(const LocationSharingLoading());
    final sharesResult = await getMyShares(event.userId);
    final sharedResult = await getSharedWithMe(event.userId);

    sharesResult.fold(
      (_) {},
      (shares) {
        emit(state.copyWith(
          myShares: shares,
          trustedContacts: shares
              .where((s) => s.active)
              .map((s) => TrustedContact(
                    userId: s.targetUserId,
                    name: '',
                    lastName: '',
                    email: '',
                    sharedSince: s.createdAt.toIso8601String(),
                  ))
              .toList(),
          isSharingActive: shares.any((s) => s.active),
        ));
      },
    );

    sharedResult.fold(
      (_) {},
      (shared) => emit(state.copyWith(sharedWithMe: shared)),
    );
  }

  Future<void> _onStartSharing(
      StartSharingEvent event, Emitter<LocationSharingState> emit) async {
    emit(const LocationSharingLoading());
    if (state.myShares.length >= 5) {
      emit(state.copyWith(
          addContactError: 'Máximo 5 contactos permitidos'));
      return;
    }

    if (state.myShares.any((s) =>
        s.targetUserId.toString() == event.targetUserId.toString() &&
        s.active)) {
      emit(state.copyWith(
          addContactError: 'Ya compartes ubicación con este usuario'));
      return;
    }

    final result = await startSharing(
      targetUserId: event.targetUserId,
      userId: event.userId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
          addContactError: failure.message)),
      (_) => add(LoadSharingDataEvent(userId: event.userId)),
    );
  }

  Future<void> _onStopSharing(
      StopSharingEvent event, Emitter<LocationSharingState> emit) async {
    final result = await stopSharing(
      targetUserId: event.targetUserId,
      userId: event.userId,
    );
    result.fold(
      (_) {},
      (_) => add(LoadSharingDataEvent(userId: event.userId)),
    );
  }

  Future<void> _onLoadFriends(LoadFriendsLocationsEvent event,
      Emitter<LocationSharingState> emit) async {
    final result = await getFriendsLocations(event.userId);
    result.fold(
      (_) {},
      (locations) => emit(state.copyWith(friendsLocations: locations)),
    );
  }

  void _onClearError(
      ClearAddContactErrorEvent event, Emitter<LocationSharingState> emit) {
    emit(state.copyWith(addContactError: null));
  }
}

class TrustedContact {
  final int userId;
  final String name;
  final String lastName;
  final String email;
  final String sharedSince;

  const TrustedContact({
    required this.userId,
    required this.name,
    required this.lastName,
    required this.email,
    required this.sharedSince,
  });
}
