import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/district.dart';
import '../repositories/district_repository.dart';

class GetAllDistricts {
  final DistrictRepository repository;

  GetAllDistricts(this.repository);

  Future<Either<Failure, List<District>>> call() {
    return repository.getAllDistricts();
  }
}

class GetDangerousDistricts {
  final DistrictRepository repository;

  GetDangerousDistricts(this.repository);

  Future<Either<Failure, List<District>>> call({int minRiskLevel = 3}) {
    return repository.getDangerousDistricts(minRiskLevel: minRiskLevel);
  }
}
