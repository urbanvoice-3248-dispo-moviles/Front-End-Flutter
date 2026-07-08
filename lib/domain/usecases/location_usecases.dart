import 'package:dartz/dartz.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';
import '../../core/errors/failures.dart';

/// Obtiene todas las ubicaciones de riesgo disponibles para el mapa.
class GetAllLocations {
  final LocationRepository repository;

  GetAllLocations(this.repository);

  Future<Either<Failure, List<Location>>> call() {
    return repository.getAllLocations();
  }
}

/// Busca ubicaciones dentro de un radio alrededor de una coordenada.
class GetNearbyLocations {
  final LocationRepository repository;

  GetNearbyLocations(this.repository);

  Future<Either<Failure, List<Location>>> call({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) {
    return repository.getNearbyLocations(
      latitude: latitude,
      longitude: longitude,
      radiusInKm: radiusInKm,
    );
  }
}

/// Filtra ubicaciones por distrito para vistas o busquedas localizadas.
class GetLocationsByDistrict {
  final LocationRepository repository;

  GetLocationsByDistrict(this.repository);

  Future<Either<Failure, List<Location>>> call(String district) {
    return repository.getLocationsByDistrict(district);
  }
}

/// Obtiene zonas consideradas peligrosas desde un nivel minimo de riesgo.
class GetDangerousLocations {
  final LocationRepository repository;

  GetDangerousLocations(this.repository);

  Future<Either<Failure, List<Location>>> call({int minRiskLevel = 3}) {
    return repository.getDangerousLocations(minRiskLevel: minRiskLevel);
  }
}
