import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/alert_config.dart';
import '../../domain/repositories/alert_config_repository.dart';
import '../datasources/alert_config_remote_datasource.dart';
import '../models/alert_config_model.dart';

class AlertConfigRepositoryImpl implements AlertConfigRepository {
  final AlertConfigRemoteDataSource _remoteDataSource;

  AlertConfigRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AlertConfig>> getAlertConfig(int userId) async {
    try {
      final model = await _remoteDataSource.getAlertConfig(userId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Right(AlertConfig(
          id: 0,
          userId: 0,
          enabled: true,
          radiusInKm: 0,
          notifyByEmail: false,
        ));
      }
      return Left(
          ServerFailure(e.message ?? 'Error al obtener configuración'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlertConfig>> updateAlertConfig({
    required int userId,
    bool? enabled,
    double? radiusInKm,
    bool? notifyByEmail,
  }) async {
    try {
      final request = UpdateAlertConfigRequest(
        enabled: enabled,
        radiusInKm: radiusInKm,
        notifyByEmail: notifyByEmail,
      );
      final model = await _remoteDataSource.updateAlertConfig(userId, request);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al actualizar configuración'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
