import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReportStatistics>> getStatistics() async {
    try {
      final dto = await _remoteDataSource.getStatistics();
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener estadísticas'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
