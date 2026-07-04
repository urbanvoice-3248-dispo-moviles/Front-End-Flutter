import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/route_assessment.dart';
import '../repositories/route_repository.dart';

class AssessRoute {
  final RouteRepository repository;

  AssessRoute(this.repository);

  Future<Either<Failure, RouteAssessment>> call(
      List<Map<String, double>> waypoints) {
    return repository.assessRoute(waypoints);
  }
}
