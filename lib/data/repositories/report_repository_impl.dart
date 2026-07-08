import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/incident_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, IncidentReport>> createReport({
    required int userId,
    required String title,
    required String description,
    required String incidentType,
    required double latitude,
    required double longitude,
    String? address,
    String? mediaUrl,
    bool isAnonymous = false,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'incident_type': incidentType,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'media_url': mediaUrl,
        'is_anonymous': isAnonymous,
      };
      final model = await _remoteDataSource.createReport(data, userId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al crear reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentReport>> getReportById(int id) async {
    try {
      final model = await _remoteDataSource.getReportById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Reporte no encontrado'));
      }
      return Left(ServerFailure(e.message ?? 'Error al obtener reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentReport>>> getReportsByUser(
      int userId) async {
    try {
      final models = await _remoteDataSource.getReportsByUser(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al obtener reportes'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentReport>>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    try {
      final models = await _remoteDataSource.getNearbyReports(
          latitude, longitude, radiusInKm);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al obtener reportes'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentReport>> updateReport({
    required int id,
    required String title,
    required String description,
    String? mediaUrl,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'media_url': mediaUrl,
      };
      final model = await _remoteDataSource.updateReport(id, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al actualizar reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReport(int id) async {
    try {
      await _remoteDataSource.deleteReport(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al eliminar reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentReport>> approveReport(int id) async {
    try {
      final model = await _remoteDataSource.approveReport(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al aprobar reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentReport>> rejectReport(int id) async {
    try {
      final model = await _remoteDataSource.rejectReport(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al rechazar reporte'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
