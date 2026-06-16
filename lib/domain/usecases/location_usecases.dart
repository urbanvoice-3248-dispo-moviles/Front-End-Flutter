import 'package:dartz/dartz.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';
import '../../core/errors/failures.dart';

class GetAllLocations {
  final LocationRepository repository;

  GetAllLocations(this.repository);

  Future<Either<Failure, List<Location>>> call() {
    return repository.getAllLocations();
  }
}

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

class GetLocationsByDistrict {
  final LocationRepository repository;

  GetLocationsByDistrict(this.repository);

  Future<Either<Failure, List<Location>>> call(String district) {
    return repository.getLocationsByDistrict(district);
  }
}

class GetDangerousLocations {
  final LocationRepository repository;

  GetDangerousLocations(this.repository);

  Future<Either<Failure, List<Location>>> call({int minRiskLevel = 3}) {
    return repository.getDangerousLocations(minRiskLevel: minRiskLevel);
  }
}
