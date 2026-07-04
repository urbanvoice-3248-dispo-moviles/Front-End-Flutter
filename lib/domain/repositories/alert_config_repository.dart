import 'package:dartz/dartz.dart';
import '../entities/alert_config.dart';
import '../../core/errors/failures.dart';

abstract class AlertConfigRepository {
  Future<Either<Failure, AlertConfig>> getAlertConfig(int userId);

  Future<Either<Failure, AlertConfig>> updateAlertConfig({
    required int userId,
    bool? enabled,
    double? radiusInKm,
    bool? notifyByEmail,
  });
}
