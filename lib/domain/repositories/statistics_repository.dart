import 'package:dartz/dartz.dart';
import '../entities/statistics.dart';
import '../../core/errors/failures.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, ReportStatistics>> getStatistics();
}
