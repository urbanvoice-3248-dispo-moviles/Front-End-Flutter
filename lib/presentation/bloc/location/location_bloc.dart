import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/location.dart';
import '../../../domain/usecases/location_usecases.dart';

part 'location_event.dart';
part 'location_state.dart';

/// Orquesta las consultas de ubicaciones que alimentan el mapa de riesgo.
///
/// Cada evento delega en un caso de uso de dominio y transforma el resultado
/// en estados simples para que la capa de presentacion solo reaccione a datos,
/// carga o error.
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

  /// Carga todas las ubicaciones disponibles sin aplicar filtros.
  Future<void> _onGetAll(
      GetAllLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result = await getAllLocations();
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  /// Carga ubicaciones cercanas a una coordenada y radio determinados.
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

  /// Carga ubicaciones pertenecientes a un distrito especifico.
  Future<void> _onGetByDistrict(
      GetLocationsByDistrictEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final result = await getLocationsByDistrict(event.district);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  /// Carga ubicaciones que superan el nivel minimo de riesgo solicitado.
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
