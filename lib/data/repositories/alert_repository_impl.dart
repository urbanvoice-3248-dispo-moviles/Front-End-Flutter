import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../datasources/alert_remote_datasource.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource _remoteDataSource;

  AlertRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Alert>>> getAllAlerts() async {
    try {
      final models = await _remoteDataSource.getAllAlerts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener alertas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Alert>> getAlertById(int id) async {
    try {
      final model = await _remoteDataSource.getAlertById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Alerta no encontrada'));
      }
      return Left(ServerFailure(e.message ?? 'Error al obtener alerta'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Alert>>> getAlertsByUser(int userId) async {
    try {
      final models = await _remoteDataSource.getAlertsByUser(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener alertas del usuario'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlert(int id) async {
    try {
      await _remoteDataSource.deleteAlert(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al eliminar alerta'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
