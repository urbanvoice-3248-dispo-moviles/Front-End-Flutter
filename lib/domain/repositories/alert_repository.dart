import 'package:dartz/dartz.dart';
import '../entities/alert.dart';
import '../../core/errors/failures.dart';

abstract class AlertRepository {
  Future<Either<Failure, List<Alert>>> getAllAlerts();

  Future<Either<Failure, Alert>> getAlertById(int id);

  Future<Either<Failure, List<Alert>>> getAlertsByUser(int userId);

  Future<Either<Failure, void>> deleteAlert(int id);
}
