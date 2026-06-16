import 'package:dartz/dartz.dart';
import '../entities/location.dart';
import '../../core/errors/failures.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> getAllLocations();

  Future<Either<Failure, Location>> getLocationById(int id);

  Future<Either<Failure, List<Location>>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });

  Future<Either<Failure, List<Location>>> getLocationsByDistrict(
      String district);

  Future<Either<Failure, List<Location>>> getDangerousLocations({
    int minRiskLevel = 3,
  });
}
