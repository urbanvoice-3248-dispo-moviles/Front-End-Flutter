part of 'location_sharing_bloc.dart';

class LocationSharingState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? addContactError;
  final UserLiveLocation? myLocation;
  final List<UserLiveLocation> friendsLocations;
  final List<ShareSession> myShares;
  final List<ShareSession> sharedWithMe;
  final List<TrustedContact> trustedContacts;
  final bool isSharingActive;

  const LocationSharingState({
    this.isLoading = false,
    this.error,
    this.addContactError,
    this.myLocation,
    this.friendsLocations = const [],
    this.myShares = const [],
    this.sharedWithMe = const [],
    this.trustedContacts = const [],
    this.isSharingActive = false,
  });

  LocationSharingState copyWith({
    bool? isLoading,
    String? error,
    String? addContactError,
    UserLiveLocation? myLocation,
    List<UserLiveLocation>? friendsLocations,
    List<ShareSession>? myShares,
    List<ShareSession>? sharedWithMe,
    List<TrustedContact>? trustedContacts,
    bool? isSharingActive,
  }) {
    return LocationSharingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      addContactError: addContactError,
      myLocation: myLocation ?? this.myLocation,
      friendsLocations: friendsLocations ?? this.friendsLocations,
      myShares: myShares ?? this.myShares,
      sharedWithMe: sharedWithMe ?? this.sharedWithMe,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      isSharingActive: isSharingActive ?? this.isSharingActive,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        addContactError,
        myLocation,
        friendsLocations,
        myShares,
        sharedWithMe,
        trustedContacts,
        isSharingActive,
      ];
}

class LocationSharingInitial extends LocationSharingState {
  const LocationSharingInitial();
}

class LocationSharingLoading extends LocationSharingState {
  const LocationSharingLoading() : super(isLoading: true);
}
