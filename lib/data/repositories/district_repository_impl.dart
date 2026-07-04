import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/district.dart';
import '../../domain/repositories/district_repository.dart';
import '../datasources/district_remote_datasource.dart';

class DistrictRepositoryImpl implements DistrictRepository {
  final DistrictRemoteDataSource _remoteDataSource;

  DistrictRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<District>>> getAllDistricts() async {
    try {
      final models = await _remoteDataSource.getAllDistricts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener distritos'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, District>> getDistrictById(int id) async {
    try {
      final model = await _remoteDataSource.getDistrictById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Distrito no encontrado'));
      }
      return Left(
          ServerFailure(e.message ?? 'Error al obtener distrito'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<District>>> getDangerousDistricts(
      {int minRiskLevel = 3}) async {
    try {
      final models =
          await _remoteDataSource.getDangerousDistricts(minRiskLevel: minRiskLevel);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.message ?? 'Error al obtener distritos peligrosos'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
