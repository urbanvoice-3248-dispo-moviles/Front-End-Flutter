import 'package:dartz/dartz.dart';
import '../entities/alert.dart';
import '../repositories/alert_repository.dart';
import '../../core/errors/failures.dart';

class GetAllAlerts {
  final AlertRepository repository;

  GetAllAlerts(this.repository);

  Future<Either<Failure, List<Alert>>> call() {
    return repository.getAllAlerts();
  }
}

class GetAlertsByUser {
  final AlertRepository repository;

  GetAlertsByUser(this.repository);

  Future<Either<Failure, List<Alert>>> call(int userId) {
    return repository.getAlertsByUser(userId);
  }
}
