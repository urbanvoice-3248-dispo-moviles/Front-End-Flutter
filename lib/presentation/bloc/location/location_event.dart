part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class GetAllLocationsEvent extends LocationEvent {}

class GetNearbyLocationsEvent extends LocationEvent {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  const GetNearbyLocationsEvent({
    required this.latitude,
    required this.longitude,
    this.radiusInKm = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusInKm];
}

class GetLocationsByDistrictEvent extends LocationEvent {
  final String district;

  const GetLocationsByDistrictEvent(this.district);

  @override
  List<Object?> get props => [district];
}

class GetDangerousLocationsEvent extends LocationEvent {
  final int minRiskLevel;

  const GetDangerousLocationsEvent({this.minRiskLevel = 3});

  @override
  List<Object?> get props => [minRiskLevel];
}
