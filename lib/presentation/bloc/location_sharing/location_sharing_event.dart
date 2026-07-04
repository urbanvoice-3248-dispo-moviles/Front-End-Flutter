part of 'location_sharing_bloc.dart';

abstract class LocationSharingEvent extends Equatable {
  const LocationSharingEvent();

  @override
  List<Object?> get props => [];
}

class PublishMyLocationEvent extends LocationSharingEvent {
  final double latitude;
  final double longitude;
  final int userId;

  const PublishMyLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.userId,
  });

  @override
  List<Object?> get props => [latitude, longitude, userId];
}

class LoadSharingDataEvent extends LocationSharingEvent {
  final int userId;

  const LoadSharingDataEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class StartSharingEvent extends LocationSharingEvent {
  final int targetUserId;
  final int userId;

  const StartSharingEvent({
    required this.targetUserId,
    required this.userId,
  });

  @override
  List<Object?> get props => [targetUserId, userId];
}

class StopSharingEvent extends LocationSharingEvent {
  final int targetUserId;
  final int userId;

  const StopSharingEvent({
    required this.targetUserId,
    required this.userId,
  });

  @override
  List<Object?> get props => [targetUserId, userId];
}

class LoadFriendsLocationsEvent extends LocationSharingEvent {
  final int userId;

  const LoadFriendsLocationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearAddContactErrorEvent extends LocationSharingEvent {}
