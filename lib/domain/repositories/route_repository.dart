import 'package:dartz/dartz.dart';
import '../entities/route_assessment.dart';
import '../../core/errors/failures.dart';

abstract class RouteRepository {
  Future<Either<Failure, RouteAssessment>> assessRoute(
      List<Map<String, double>> waypoints);
}
