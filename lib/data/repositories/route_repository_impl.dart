import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/route_assessment.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/route_remote_datasource.dart';
import '../models/route_assessment_model.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource _remoteDataSource;

  RouteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RouteAssessment>> assessRoute(
      List<Map<String, double>> waypoints) async {
    try {
      final request = RouteAssessmentRequestDto(
        waypoints: waypoints
            .map((w) => WaypointDto(lat: w['lat']!, lng: w['lng']!))
            .toList(),
      );
      final response = await _remoteDataSource.assessRoute(request);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al evaluar ruta'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
