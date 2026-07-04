import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/share_session.dart';
import '../../domain/repositories/location_sharing_repository.dart';
import '../datasources/location_sharing_remote_datasource.dart';

class LocationSharingRepositoryImpl implements LocationSharingRepository {
  final LocationSharingRemoteDataSource _remoteDataSource;

  LocationSharingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserLiveLocation>> publishLocation({
    required double latitude,
    required double longitude,
    required int userId,
  }) async {
    try {
      final dto = await _remoteDataSource.publishLocation(latitude, longitude, userId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al publicar ubicación'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserLiveLocation>>> getFriendsLocations(
      int userId) async {
    try {
      final dtos = await _remoteDataSource.getFriendsLocations(userId);
      return Right(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.message ?? 'Error al obtener ubicaciones de contactos'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLiveLocation?>> getMyLocation(int userId) async {
    try {
      final dto = await _remoteDataSource.getMyLocation(userId);
      return Right(dto?.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener ubicación'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShareSession>> startSharing({
    required int targetUserId,
    required int userId,
  }) async {
    try {
      final dto = await _remoteDataSource.startSharing(targetUserId, userId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al iniciar compartición'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopSharing({
    required int targetUserId,
    required int userId,
  }) async {
    try {
      await _remoteDataSource.stopSharing(targetUserId, userId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al detener compartición'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShareSession>>> getMyShares(int userId) async {
    try {
      final dtos = await _remoteDataSource.getMyShares(userId);
      return Right(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.message ?? 'Error al obtener comparticiones'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShareSession>>> getSharedWithMe(
      int userId) async {
    try {
      final dtos = await _remoteDataSource.getSharedWithMe(userId);
      return Right(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.message ?? 'Error al obtener comparticiones recibidas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
