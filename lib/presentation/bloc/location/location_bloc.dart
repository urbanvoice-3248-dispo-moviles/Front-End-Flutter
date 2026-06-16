import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/location.dart';
import '../../../domain/usecases/location_usecases.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetAllLocations getAllLocations;
  final GetNearbyLocations getNearbyLocations;
  final GetLocationsByDistrict getLocationsByDistrict;
  final GetDangerousLocations getDangerousLocations;

  LocationBloc({
    required this.getAllLocations,
    required this.getNearbyLocations,
    required this.getLocationsByDistrict,
    required this.getDangerousLocations,
  }) : super(LocationInitial()) {
    on<GetAllLocationsEvent>(_onGetAll);
    on<GetNearbyLocationsEvent>(_onGetNearby);
    on<GetLocationsByDistrictEvent>(_onGetByDistrict);
    on<GetDangerousLocationsEvent>(_onGetDangerous);
  }

  Future<void> _onGetAll(
      GetAllLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result = await getAllLocations();
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  Future<void> _onGetNearby(
      GetNearbyLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result = await getNearbyLocations(
      latitude: event.latitude,
      longitude: event.longitude,
      radiusInKm: event.radiusInKm,
    );
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  Future<void> _onGetByDistrict(
      GetLocationsByDistrictEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result = await getLocationsByDistrict(event.district);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  Future<void> _onGetDangerous(
      GetDangerousLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result =
        await getDangerousLocations(minRiskLevel: event.minRiskLevel);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }
}
