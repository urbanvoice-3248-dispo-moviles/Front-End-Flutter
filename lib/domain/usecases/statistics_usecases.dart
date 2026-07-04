import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/statistics.dart';
import '../repositories/statistics_repository.dart';

class GetStatistics {
  final StatisticsRepository repository;

  GetStatistics(this.repository);

  Future<Either<Failure, ReportStatistics>> call() {
    return repository.getStatistics();
  }
}
