import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/alert_config.dart';
import '../repositories/alert_config_repository.dart';

class GetAlertConfig {
  final AlertConfigRepository repository;

  GetAlertConfig(this.repository);

  Future<Either<Failure, AlertConfig>> call(int userId) {
    return repository.getAlertConfig(userId);
  }
}

class UpdateAlertConfig {
  final AlertConfigRepository repository;

  UpdateAlertConfig(this.repository);

  Future<Either<Failure, AlertConfig>> call({
    required int userId,
    bool? enabled,
    double? radiusInKm,
    bool? notifyByEmail,
  }) {
    return repository.updateAlertConfig(
      userId: userId,
      enabled: enabled,
      radiusInKm: radiusInKm,
      notifyByEmail: notifyByEmail,
    );
  }
}
