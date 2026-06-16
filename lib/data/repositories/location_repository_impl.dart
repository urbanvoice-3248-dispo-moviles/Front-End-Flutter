import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  LocationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Location>>> getAllLocations() async {
    try {
      final models = await _remoteDataSource.getAllLocations();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al obtener ubicaciones'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Location>> getLocationById(int id) async {
    try {
      final model = await _remoteDataSource.getLocationById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Ubicación no encontrada'));
      }
      return Left(ServerFailure(e.message ?? 'Error al obtener ubicación'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    try {
      final models = await _remoteDataSource.getNearbyLocations(
          latitude, longitude, radiusInKm);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener ubicaciones cercanas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getLocationsByDistrict(
      String district) async {
    try {
      final models =
          await _remoteDataSource.getLocationsByDistrict(district);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener ubicaciones'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getDangerousLocations({
    int minRiskLevel = 3,
  }) async {
    try {
      final models =
          await _remoteDataSource.getDangerousLocations(minRiskLevel: minRiskLevel);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener zonas peligrosas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
