import 'package:dartz/dartz.dart';
import '../entities/district.dart';
import '../../core/errors/failures.dart';

abstract class DistrictRepository {
  Future<Either<Failure, List<District>>> getAllDistricts();

  Future<Either<Failure, District>> getDistrictById(int id);

  Future<Either<Failure, List<District>>> getDangerousDistricts(
      {int minRiskLevel = 3});
}
